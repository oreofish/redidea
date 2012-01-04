class AdminsController < ApplicationController
  before_filter :authenticate_user!
	
	# POST /ranks
	def admin
		if can? :rank, Idea
			@ideas = Idea.find_by_sql("SELECT ideas.*,SUM(likes.score) AS scores,COUNT(likes.idea_id) AS counts From ideas,likes WHERE likes.idea_id=ideas.id GROUP BY likes.idea_id ORDER BY scores DESC")
		else 
			redirect_to ideas_path
		end
	end
end
