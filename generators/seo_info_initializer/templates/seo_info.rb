ActiveRecord::Base.send "include", SeoInfo::ActiveRecord::ActiveRecordAdapter
ActionController::Base.send "include", SeoInfo::ActionController::ActionControllerAdapter