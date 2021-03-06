class VotesController < GroupBaseController
  belongs_to :motion
  # before_filter :ensure_group_member
  # belongs_to :motion

  # def begin_of_association_chain
  #   @motion
  #

  def destroy
    resource
    if @motion.voting?
      destroy! { @motion }
    else
      flash[:error] = "You can only delete your vote during the 'voting' phase"
      redirect_to @motion
    end
  end

  def create
    build_resource
    @vote.user = current_user
    if @motion.voting?
      create! { @motion }
    else
      flash[:error] = "Can only vote in voting phase"
      redirect_to @motion
    end
  end

  def update
    resource
    if @motion.voting?
      @vote.update_attributes(params[:vote])
      flash[:notice] = "Vote updated."
      @vote.save
    else
      flash[:error] = "Can only vote in voting phase"
    end
    redirect_to @motion
  end

  private

    def group
      group = Motion.find(params[:motion_id]).group
    end
end
