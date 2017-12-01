class LeadsController < InheritedResources::Base
  layout 'new'
  def new
    @lead = Lead.new
  end

  def create
    @lead = Lead.new(lead_params)

    if @lead.save
      render 'success'
    else
      render 'new'
    end
  end

  def success

  end

  private

    def lead_params
      params.require(:lead).permit(:email)
    end
end

