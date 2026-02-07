// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EducationCrowdfunding {

    struct Campaign {
        address creator;
        string title;
        string description;
        uint goal;
        uint deadline;
        uint raised;
        bool completed;
    }

    uint public campaignCount;
    mapping(uint => Campaign) public campaigns;

    event CampaignCreated(uint id, address creator, uint goal);
    event DonationMade(uint id, address donor, uint amount);
    event FundsWithdrawn(uint id);

    function createCampaign(
        string memory _title,
        string memory _description,
        uint _goal,
        uint _duration
    ) external {
        campaignCount++;

        campaigns[campaignCount] = Campaign(
            msg.sender,
            _title,
            _description,
            _goal,
            block.timestamp + _duration,
            0,
            false
        );

        emit CampaignCreated(campaignCount, msg.sender, _goal);
    }

    function donate(uint _id) external payable {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp < campaign.deadline, "Campaign ended");
        require(!campaign.completed, "Campaign completed");

        campaign.raised += msg.value;
        emit DonationMade(_id, msg.sender, msg.value);
    }

    function withdrawFunds(uint _id) external {
    Campaign storage campaign = campaigns[_id];
    require(msg.sender == campaign.creator, "Not creator");
    require(campaign.raised >= campaign.goal, "Goal not reached");
    require(!campaign.completed, "Already withdrawn");

    campaign.completed = true;

    (bool success, ) = payable(campaign.creator).call{value: campaign.raised}("");
    require(success, "Transfer failed");

    emit FundsWithdrawn(_id);
}

}
