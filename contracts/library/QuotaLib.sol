pragma solidity ^0.4.24;

import "../zeppelin/SafeMath.sol";


/**
 * @title QuotaLib 
 */
library QuotaLib {    
    using SafeMath for uint;

    struct Storage {
        mapping (address => uint) claimedShares;
        uint claimedAmount;
    }

    /**     
     * @dev Claim share if some available.
     */
    function claimShare(Storage storage self, address addr, uint currentAmount, uint[2] fraction) internal returns (uint) {
        uint totalShare = calcShare(currentAmount.add(self.claimedAmount), fraction);
        uint claimedShare = self.claimedShares[addr];        
        assert(totalShare >= claimedShare);
        if(totalShare == claimedShare) {
            return 0;
        }

        uint claimed = totalShare - claimedShare;
        self.claimedShares[addr] = self.claimedShares[addr].add(claimed);
        self.claimedAmount = self.claimedAmount.add(claimed);

        return claimed;
    }

    /**     
     * @dev ...
     */
    function undoClaimShare(Storage storage self, address addr, uint amount) internal {
        assert(self.claimedShares[addr] >= amount);
        self.claimedShares[addr] -= amount;
        self.claimedAmount -= amount;
    }

    /**     
     * @dev ...
     */
    function calcShare(uint amount, uint[2] fraction) private pure returns (uint) {
        return amount.mul(fraction[0]).div(fraction[1]);
    }
}