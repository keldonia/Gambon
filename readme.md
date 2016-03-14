Gambom
======

Gambom is lightweight MVC framework with a built-in in ORM that allows for updates to a Postgres database to be run with minimal additional SQL code.  Gambom was inspired by Rails and Sinatra and strives to create a framework with minimal overhead.

How to use Gambom
-----------------

You will need the following:
  * Ruby
  * Postgres

0. Then open your command line in the Gambom folder and run `gem build gambom.gemspec` (this is a placeholder until it is uploaded to rubygems).  This will create the v 0.1.0 version of the gem.


1. `gem install gambom-0.1.0.gem`
2. `gambom new [name of your app]`
3. `gambom db create`
4. It's ready!

Command Line Interface
----------------------

Enter `gambom` into the command line to see the full list of available commands.

* `gambom new [name]`
* `gambom server`
* `gambom generate`
  * `model [model name]`
  * `controller [controller name]`
  * `migration`
* `gambom db`
  * `create`
  * `migrate`
  * `seed`
  * `reset`

Gambom ORM
----------

Gambom's object relational mapping is similar to Rail's ActiveRecord, converting tables in a Postgres database into instances of `Gambom::SQLObject` class.

`Gambom::SQLObject` is a lightweight ORM, that features base CRUD methods and associations, without additional overhead.  Additionally, through its setup it reduces the number of necessary database queries further reducing overhead.

###All your CRUD methods are available to you, including:
* `#create`
* `#find`
* `#all`
* `#update`
* `#destroy`

###Builds out table associations, including:
* `::belongs_to`
* `::has_many`
* `::has_one_through`
* `::has_many_through`

##`Gambom::SQLRelation`
Allows for the ordering and searching of the database with minimal querying of the database.  This is possible through lazy, stackable methods.  The queries are only fired on `Gambom::SQLRelation#load` or when it is coerced into an Array.

###Methods include:
* `::all`
* `::where`
* `::includes`
* `::find`
* `::order`
* `::limit`
* `::count`
* `::first`
* `::last`

###Make use of Eager Loading to Reduce Queries
Preload associations by calling `Gambom::SQLRelation#includes`
Reduces queries from (n + 1) to 2.

Database
--------

Gambom commands prefixed with 'db:' interact with the Postgres database
* `gambom db create` will drop any Postgres database named 'Gambom' and will replace it with a new empty database.
* `gambom db migrate` finds any SQL files under db/migrate that haven't been run and will copy them to the database.
* `gambom db seed` calls the `Seed::populate` method in dd/seed.rb allowing you to quickly seed your development database.
* `gambom db reset` executes all three of the above commands in succession.

Migrations
----------

Entering `gambom generate migration [migration name]` in the command line will create a new time-stamped SQL file in db/migrations.  Write the appropriate SQL commands in this file and these commands will be staged, and `gambom db migrate` will actually implement them.

_*WARNING:*_ To reverse a migration you must generate a new migration to undo the change.  Solely deleting the original migration won't have any effect (unless you reset or create a new database, but you wouldn't do that ;) ).

`Gambom::ControllerBase`
------------------------

Connects your models to your routes, allows access to the DB through html.erb views!

Router
------

Routes are in config/routes.rb  New routes are composed using Regex.  Open a new server connection with `gambom server`.

Gambom Console
--------------

Access the database with `Gambom::SQLObject` methods by entering `require gambom` in Pry or IRB.
