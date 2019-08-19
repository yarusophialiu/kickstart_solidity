pragma solidity ^0.4.17;

contract CampaignFactory {
    address[] public deployedCampaigns;
    
    function createCampaign(uint minimum) public {
       address newCampaign = new Campaign(minimum, msg.sender);
       deployedCampaigns.push(newCampaign);
    }
    
    function getDeployedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }
}

contract Campaign {
    // just a type not an instance of var
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        // number of yes vote
        uint approvalCount;
        // people who have voted
        // reference type
        mapping(address => bool) approvals;
    }
    
    Request[] public requests;
    address public manager;
    uint public minimumContribution;
    // people who donote money 
    mapping(address => bool) public approvers;
    uint public approversCount;
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    function Campaign(uint minimum, address creator) public {
        manager = creator;
        minimumContribution = minimum;
    }
    
    function contribute() public payable {
        require(msg.value > minimumContribution);
        approvers[msg.sender] = true;
        approversCount++;
    }
    
    function createRequest(string description, uint value, address recipient) public restricted {
        Request memory newRequest = Request({
            description: description, 
            value: value, 
            recipient: recipient,
            complete: false,
            approvalCount: 0
        });
        
        requests.push(newRequest);
    }
    
    function approveRequest(uint index) public {
        Request storage request = requests[index];
        // is a donator?
        require(approvers[msg.sender]);
        // has not voted?
        require(!requests[index].approvals[msg.sender]);
        request.approvalCount++;
        request.approvals[msg.sender] = true;
    }

    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];
        require(request.approvalCount > (approversCount /2));
        require(!request.complete);
        request.recipient.transfer(request.value);
        requests[index].complete = true;
    }
}