require 'pg'

APP_NAME = "Gambon"
PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'

class DBConnection
  def self.open
    @db = PG::Connection.new( dbname: APP_NAME, port: 5432)
  end

  def self.reset
    commands = [
      "dropdb #{APP_NAME}",
      "createdb #{APP_NAME}"
    ]

    commands.each { |command| `#{command}` }
  end

  def self.migrate
    ensure_version_table
    to_migrate = MIGRATIONS.reject { |file| has_migrated?(file) }
    to_migrate.each { |file| add_to_version(file) }
    to_migrate.map {|file| "psql -d #{APP_NAME} -a -f #{file}"}
              .each {|command| `#{command}`}
  end

  def self.parse_migration_file(file)
    filename = File.basename(file).split(".").first
    u_idx = filename.index("_")
    filename[0..u_idx - 1]
  end

  def self.has_migrated?(file)
    name = parse_migration_file(file)
    result = execute(<<-SQL, [name])
      SELECT
        *
      FROM
        version
      WHERE
        name = $1;
    SQL
    !!result.first
  end

  def self.add_to_version(file)
    name = parse_migration_file(file)
    execute(<<-SQL, [name])
      INSERT INTO
        version (name)
      VALUES
        ($1);
    SQL
  end

  def self.instance
    reset if @db.nil?

    @db
  end

  def self.execute(*args)
    print_query(*args)
    instance.execute(*args)
  end

  def self.execute2(*args)
    print_query(*args)
    instance.execute2(*args)
  end

  def self.last_insert_row_id
    instance.last_insert_row_id
  end

  def self.ensure_version_table
   table = nil

   if table.nil?
     self.execute(<<-SQL)
       CREATE TABLE IF NOT EXISTS version (
         id SERIAL PRIMARY KEY,
         name VARCHAR(255) NOT NULL
       );
     SQL
   end
 end

 def self.columns(table_name)
   columns = instance.exec(<<-SQL)
     SELECT
       attname
     FROM
       pg_attribute
     WHERE
       attrelid = '#{table_name}'::regclass AND
       attnum > 0 AND
       NOT attisdropped
   SQL

   columns.map { |col| col['attname'].to_sym }
 end

  private

  def self.print_query(query, *interpolation_args)
    return unless PRINT_QUERIES

    puts '--------------------'
    puts query
    unless interpolation_args.empty?
      puts "interpolate: #{interpolation_args.inspect}"
    end
    puts '--------------------'
  end
end
