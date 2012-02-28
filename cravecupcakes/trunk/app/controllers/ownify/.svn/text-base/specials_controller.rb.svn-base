class Ownify::SpecialsController < LoginController
  def index
    if get_access_level != 1
      access_denied
    else
      list
      render :action => 'list'
    end
    
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    if get_access_level != 1
      access_denied
    else
      @specials = Special.find(:all, :order => "title", :page => { :size => 30, :current => params[:page] })
    end
    
  end

  def new
    if get_access_level != 1
      access_denied
    else
      @special = Special.new
    end
    
  end

  def create

 
    @error = ""
    for a in params[:cupcake]
        if a[1] != "" && a[1].to_i < 1
          @error = "Cupcake flavor boxes should contain a number or be left blank."
          break
        end
    end
     
    @special = Special.new(params[:special])
    saved = @special.save

    if saved && @error == ""

      for cupcake in params[:cupcake]
        if cupcake[1] != ""
          SpecialCupcake.new(
            :special_id => @special.id,
            :cupcake_id => cupcake[0],
            :qty => cupcake[1]
          ).save
        end
      end

      flash[:notice] = 'The Seasonal or Favorite Box item was successfully created.'
			expire_all_pages
      redirect_to :action => 'list'
    else
      if saved
        Special.find(@special.id).destroy
      end
      render :action => 'new'
    end

  end

  def edit
    if get_access_level != 1
      access_denied
    else
      @special = Special.find(params[:id])
      @cupcakes = SpecialCupcake.find(:all, :conditions => ["special_id = ?", params[:id]])
    end
    
  end

  def update

    @error = ""
    for a in params[:cupcake]
        if a[1] != "" && a[1].to_i < 1
          @error = "Cupcake flavor boxes should contain a number or be left blank."
          break
        end
    end

    @special = Special.find(params[:id])
    if @special.update_attributes(params[:special]) && @error == ""

      items = SpecialCupcake.find(:all, :conditions => ["special_id = ?", params[:id]])
      for item in items
        item.destroy
      end

      for cupcake in params[:cupcake]
        if cupcake[1] != ""
          SpecialCupcake.new(
            :special_id => @special.id,
            :cupcake_id => cupcake[0],
            :qty => cupcake[1]
          ).save
        end
      end

      flash[:notice] = 'The Seasonal or Favorite Box item was successfully updated.'
						expire_all_pages
      redirect_to :action => 'list', :id => @special
    else
      render :action => 'edit'
    end
  end

  def destroy
    Special.find(params[:id]).destroy

    items = SpecialCupcake.find(:all, :conditions => ["special_id = ?", params[:id]])
    for item in items
      item.destroy
    end

		expire_all_pages
    redirect_to :action => 'list'
  end
end
