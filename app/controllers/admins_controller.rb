class AdminsController < ApplicationController
  before_filter :authenticate_user!
	
	# POST /ranks
	def admin
		if can? :rank, Idea
			@scope = params[:scope] || 'rank'
			@scopes= [:rank, :email]
			if @scope == "rank"
				@ideas = Idea.find_by_sql("SELECT ideas.*,SUM(likes.score) AS scores,COUNT(likes.idea_id) AS counts From ideas,likes WHERE likes.idea_id=ideas.id GROUP BY likes.idea_id ORDER BY scores DESC")
			elsif @scope == "email"
				
			end

    	respond_to do |format|
      	format.html # index.html.erb
      	format.js
    	end

		else 
			redirect_to ideas_path
		end
	end
end
