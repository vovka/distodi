class LeadsController < InheritedResources::Base

  def create
    lead = Lead.new(lead_params)

    lead.save
    redirect_to :back
  end

  private

    def lead_params
      params.require(:lead).permit(:email)
    end
end

