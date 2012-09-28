class Public::StudentsController < ApplicationController
  inherit_resources

  defaults :finder => :find_by_secure_id!

  actions :all, :only => [:show]
end
