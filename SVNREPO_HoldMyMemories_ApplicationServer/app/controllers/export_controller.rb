class ExportController < ApplicationController
	
	def rejectExport
		exp = Export.find(params[:id])
		exp.status = 'rejected'
		exp.save
		flash[:notice_reg]="The imported moment has been rejected"
    if(session[:sharepath]=='fnf')
  
   redirect_to :controller => "customers", :action => 'list_imports'
  else
  redirect_to :controller => "tags", :action => 'coverflow'
 end
 end

	def previewExport
	end
 
  def getexportlist
    @exportlist = Export.find_by_sql("select hmm_users.v_user_name,exports.status,exports.export_type,hmm_users.v_myimage,hmm_users.img_url
            from exports,hmm_users where exports.exported_from=#{logged_in_hmm_user.id} and exports.exported_to=hmm_users.id")
    render :layout => false
  end
end
