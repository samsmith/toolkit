require 'spec_helper'

describe GroupMembershipObserver do
  subject { GroupMembershipObserver.instance }

  context "basic checks" do
    let(:gm) { FactoryGirl.build(:group_membership) }

    it "should notice when GroupMembships are saved" do
      subject.should_receive(:after_save)

      GroupMembership.observers.enable :group_membership_observer do
        gm.save
      end
    end
  end

  context "new committee members" do
    let(:thread) { FactoryGirl.create(:group_committee_message_thread) }
    let(:group_membership) { FactoryGirl.build(:group_membership, group: thread.group) }

    it "should subscribe user to committee threads if their preference is set" do
      user = group_membership.user
      user.prefs.update_column(:involve_my_groups, "subscribe")
      thread.subscribers.should_not include(user)
      thread.group.members.should_not include(user)
      GroupMembership.observers.enable :group_membership_observer do
        group_membership.role = "committee"
        group_membership.save
      end
      thread.reload
      thread.subscribers.should include(user)
    end

    it "should not subscribe them if they don't want subscribing" do
      user = group_membership.user
      user.prefs.update_column(:involve_my_groups, "notify")
      thread.subscribers.should_not include(user)
      GroupMembership.observers.enable :group_membership_observer do
        group_membership.role = "committee"
        group_membership.save
      end
      thread.reload
      thread.subscribers.should_not include(user)
    end
  end

  context "kicking out committee members" do
    let(:thread) { FactoryGirl.create(:group_committee_message_thread) }
    let(:group_membership) { FactoryGirl.create(:group_membership, group: thread.group, role: "committee") }

    it "should unsubscribe ex-committee members from committee only threads" do
      user = group_membership.user
      thread.add_subscriber(user)
      thread.subscribers.should include(user)

      GroupMembership.observers.enable :group_membership_observer do
        group_membership.role = "member"
        group_membership.save
      end

      thread.reload
      thread.subscribers.should_not include(user)
    end
  end
end
