require 'spec_helper'

describe User do
  subject do
    @user = User.new
    @user.valid?
    @user
  end
  it {should have(1).errors_on(:name)}

  it "has many groups" do
    @user = User.make!
    @group = Group.make!
    @group.add_member!(@user)
    @user.groups.should include(@group)
  end

  it 'returns an an array of user\'s group\'s motions' do
    @user = User.make
    @user.save!
    @group = Group.make
    @group.add_member!(@user)
    @group.save!
    @motion1 = Motion.make(:group => @group, :facilitator => @user, :author => @user)
    @motion1.save!
    @motion2_not_user_group = Motion.make(:group => Group.make!, :facilitator => @user, :author => User.make!)
    @motion2_not_user_group.save!
    @motion3 = Motion.make(:group => @group, :facilitator => User.make!, :author => User.make!)
    @motion3.save!
    @user.motions.size.should == 2
  end
end
