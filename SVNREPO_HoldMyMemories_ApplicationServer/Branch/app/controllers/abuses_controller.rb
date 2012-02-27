class AbusesController < ApplicationController
  # GET /abuses
  # GET /abuses.xml
  def index

    render :layout => 'false'
  end

  # GET /abuses/1
  # GET /abuses/1.xml
  def show
    
    @abuse = Abuse.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @abuse.to_xml }
    end
  end

  # GET /abuses/new
  def new
  
    @abuse = Abuse.new
    render :layout => false
    
  end

  # GET /abuses/1;edit
  def edit
  
    @abuse = Abuse.find(params[:id])
  end

  # POST /abuses
  # POST /abuses.xml
  def create
  
    @abuse = Abuse.new
   @abuse[:v_abused_by]=logged_in_hmm_user.id
    @abuse[:abused_user]=params[:id]
    @abuse[:v_comment]=params[:abuse_comments]
    respond_to do |format|
      if @abuse.save
        flash[:notice] = ' has been abused!!!'
        format.html { redirect_to abuse_url(@abuse) }
        format.html {redirect_to :controller => 'customers', :action => 'profile', :id=>params[:id]}
     else
        format.html { render :action => "new" }
        format.xml  { render :xml => @abuse.errors.to_xml }
      end
    end
    
  end

  # PUT /abuses/1
  # PUT /abuses/1.xml
  def update
    
    @abuse = Abuse.find(params[:id])

    respond_to do |format|
      if @abuse.update_attributes(params[:abuse])
        flash[:notice] = 'Abuse was successfully updated.'
        format.html { redirect_to abuse_url(@abuse) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @abuse.errors.to_xml }
      end
    end
  end

  # DELETE /abuses/1
  # DELETE /abuses/1.xml
  def destroy
    
    @abuse = Abuse.find(params[:id])
    @abuse.destroy

    respond_to do |format|
      format.html { redirect_to abuses_url }
      format.xml  { head :ok }
    end
  end
end
