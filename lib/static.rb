class Static
  attr_reader :app, :root, :file_server

  def initialize(app)
    @app = app
    @root = root
    @file_server = FileServer.new(root)
  end

  def call(env)
    req = Rack::Request.new(env)
    path = req.path

    if can_serve?(path)
      res = file_server.call(env)
    else
      res = app.call(env)
    end

    res
  end

  private

  def can_serve?(path)
    path.index("/#{root}")
  end

end

class FileServer

  MIME_TYPES = {
    '.txt'  => 'text/plain',
    '.css'  => 'text/css',
    '.html' => 'text/html',
    '.csv'  => 'text/csv',
    '.jpg'  => 'image/jpeg',
    '.jpeg' => 'image/jpeg',
    '.png'  => 'image/png',
    '.gif'  => 'image/gif',
    '.js'   => 'application/javascript',
    '.json' => 'application/json',
    '.pdf'  => 'application/pdf',
    '.xml'  => 'application/xml',
    '.zip'  => 'application/zip',
    '.mp3'  => 'audio/mp3',
    '.mp4'  => 'video/mp4',
    '.h264' => 'video/h264'
  }

  def initialize(root)
    @root = root
  end

  def call(env)
    res = Rack::Response.new
    file_name = request_file_name(env)

    if File.exist?(file_name)
      serve_file(file_name, res)
    else
      res.status = 404
      res.write("File not found")
    end

    res
  end

  private

  def serve_file(file_name, res)
    extension = File.extname(file_name)
    content_type = MIME_TYPES[extension]
    file = File.read(file_name)
    re["Content-type"] = content_type
    res.write(file)
  end

  def request_file_name(env)
    req = Rack::Request.new(env)
    path = req.path
    dir = File.dirname(__FILE__)
    File.join(dir, '..', path)
  end
end
