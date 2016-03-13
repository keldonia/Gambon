ROUTER = ROUTER.new
ROUTER.draw do
  # Example routes:

  # get Regexp.new("^/$"), MyController, :stage
  # get Regexp.new("^/ham/new$"), HamController, :new
  # get Regexp.new("^/ham/creates$"), HamController, :create
  # get Regexp.new("^/ham$"), HamController, :index
  # get Regexp.new("^/hams/(?<ham_id)>\\d+)$"), HamController, :show
end
