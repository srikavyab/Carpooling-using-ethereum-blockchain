// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.20 < 0.9.0;
import "contracts/DataBank.sol";
contract CarpoolingContract{
    mapping (uint => RegisterUsers) public registerUserList;
    uint public userindex;

    mapping(uint => PublishRide) public publishRideList;
    uint public rideindex;
    uint public rideKey;

    mapping(uint => RideBooking) public bookingList;
    uint bookingindex;
    uint bookingKey;
    constructor()
    {
        userindex = 0;
        rideindex = 0;
        rideKey = 1;

        bookingindex = 0;
        bookingKey = 1;
    }
    function RegisterUserAccount(address hashaddress,
                                string memory username,
                                string memory phonenumber, 
                                string memory email)public {
        RegisterUsers memory obj = RegisterUsers(hashaddress,0,username,phonenumber,email);
        registerUserList[userindex] = obj;
        userindex++;
        
    }

    function AddRide(
    address hashcodeaddress,
    string memory headingfrom,
    string memory headingto,
    string memory ridingdate,
    string memory ridingtime,
    uint rideamount,
    uint nop,
    string memory vtype
    )public

    {
        PublishRide memory obj = PublishRide(rideKey,hashcodeaddress,headingfrom,headingto,
        ridingdate,ridingtime,rideamount,nop,0,vtype,false,false,true);
        publishRideList[rideindex] = obj;
        rideindex++;
        rideKey++;
    }
    function searchView(uint argRideKey)public view returns(address, string memory,
    string memory,
    string memory,
    string memory ,
    uint,
    uint,uint,
    string memory,bool,bool,bool) {
            uint searchindex = argRideKey-1;

            PublishRide memory returnobj = publishRideList[searchindex];
            return (returnobj.hashcodeaddress, returnobj.headingfrom,
                returnobj.headingto, returnobj.ridingdate, returnobj.ridingtime, 
                returnobj.rideamount, returnobj.nop, returnobj.nopstatus,
                 returnobj.vtype, returnobj.isRideBookingDone,
                 returnobj.isRideOver, returnobj.rideStatus);
         }

         function loginPanel(address hashcode) view public returns (string memory,uint )
         {
            RegisterUsers memory obj;
            uint index = 0;
            uint status = 0;
            string memory rvalue = "Not found";
            while(index < userindex){
               obj =  registerUserList[index];
               if(obj.hashcodeaddress == hashcode){

                    rvalue = obj.username;
                    status = 1;
                    break;
               }
                index++;
            }
            return (rvalue,status);
         }

function getUserDetails(address hashcode) view public returns (string memory,string memory,string memory )
         {
            RegisterUsers memory obj;
            uint index = 0;
            while(index < userindex){
               obj =  registerUserList[index];
               if(obj.hashcodeaddress == hashcode){        
                    return (obj.username,obj.contactnumber,obj.emailid);
               }
                index++;
            }
            return("Not Found","Not Found","Not Found");
         }


       /*  function findUserRides(address hashcode) public returns (uint)
         {
            userRideCount = 0;
            uint index = 0;
            while(index < rideindex){
               if(publishRideList[index].hashcodeaddress == hashcode){

                    userRideCount++;
               }
                index++;
            }
        return userRideCount;
         }*/

        /*  function findPassengerRides(address hashcode) view public returns (uint)
         {
            uint passengerRideCount = 0;
            uint index = 0;
            while(index < rideindex){
               if(publishRideList[index].hashcodeaddress != hashcode){

                    passengerRideCount++;
               }
                index++;
            }
         return passengerRideCount;
         }
*/
        function getMyRides(address hashcode) view public returns(PublishRide[] memory,uint)
        {
            uint  userRideCount = 0;
            uint index = 0;
            while(index < rideindex){
               if(publishRideList[index].hashcodeaddress == hashcode){

                    userRideCount++;
               }
                index++;
            }
                PublishRide[] memory objlist = new PublishRide[](userRideCount);
                PublishRide memory obj;
                uint objindex = 0;
                index = 0;
                while(index < rideindex){
                    if(publishRideList[index].hashcodeaddress == hashcode){
                        obj = publishRideList[index];
                        objlist[objindex] = obj;
                        objindex++;
                    }
                    index++;
                }
                return (objlist,userRideCount);

            }

            function getPassengerRides(address hashcode) view public returns(PublishRide[] memory,uint)
        {
            uint passengerRideCount= 0;
            uint index = 0;
            while(index < rideindex){
               if(publishRideList[index].hashcodeaddress != hashcode){

                    passengerRideCount++;
               }
                index++;
            }
                PublishRide[] memory objlist = new PublishRide[](passengerRideCount);
                PublishRide memory obj;
                uint objindex = 0;
                index = 0;
                while(index < rideindex){
                    if(publishRideList[index].hashcodeaddress != hashcode){
                        obj = publishRideList[index];
                        objlist[objindex] = obj;
                        objindex++;
                    }
                    index++;
                }
                return (objlist,passengerRideCount);

            }

    function cancelRide(uint argRideKey)public {
            uint searchindex = argRideKey-1;

            PublishRide memory obj = publishRideList[searchindex];  
            obj.rideStatus = false;
            publishRideList[searchindex] = obj;
         }

         function activateRide(uint argRideKey)public {
            uint searchindex = argRideKey-1;

            PublishRide memory obj = publishRideList[searchindex];  
            obj.rideStatus = true;
            publishRideList[searchindex] = obj;
         }

         function MapRideBooking(uint rideno, address passenger, uint nop, uint ridecharges) public 
         {
            uint searchindex = rideno-1;

            PublishRide memory obj = publishRideList[searchindex];
            uint diffnop = obj.nop - obj.nopstatus;
            RideBooking memory RBobj;
            if(diffnop >= nop){
                    obj.nopstatus = obj.nopstatus + nop;
                    if(obj.nop == obj.nopstatus){
                    obj.isRideBookingDone = true;
                    }
                     publishRideList[searchindex] = obj;
                     
                    uint rideamount = nop * ridecharges;
                    RBobj = RideBooking(bookingKey, rideno, passenger, nop, rideamount,false,false);
                    bookingList[bookingindex] = RBobj;
                    bookingindex++;
                    bookingKey++;
                }
               
         }
        /* function approveBooking(uint _bookingKey) public {
        require(_bookingKey < bookingindex, "Invalid booking key");
        bookingList[_bookingKey].bookingstatus = true;
        }
*/

         function getNOPStatus(uint rideno) view public returns(uint)
         {
            return publishRideList[rideno-1].nopstatus;
         }

         function getRideStatus(uint rideno) view public returns(bool)
         {
            return publishRideList[rideno-1].rideStatus;
         }

         function getRideBookingDoneStatus(uint rideno) view public returns(bool)
         {
            return publishRideList[rideno-1].isRideBookingDone;
         }

         function RideNOPStatus(uint rideno,uint nop) view public returns(bool)
         {
            uint searchindex = rideno-1;
            PublishRide memory obj = publishRideList[searchindex];
            uint diffnop = obj.nop - obj.nopstatus;
            bool token = false;
            if(diffnop >= nop){
            
                token =  true;
            }
            return token;
         }

         function searchByLocation(address phashcode,string memory headingfrom, string memory headingto ) view public returns (PublishRide[] memory,uint){
            uint locRideCount= 0;
            uint index = 0;
            while(index < rideindex){
               if((keccak256(abi.encodePacked(publishRideList[index].headingfrom)) == keccak256(abi.encodePacked(headingfrom)) ||
               keccak256(abi.encodePacked(publishRideList[index].headingto)) == keccak256(abi.encodePacked(headingto))) 
               && publishRideList[index].hashcodeaddress != phashcode)
               {
                     
                     locRideCount++;
               } 
                index++;
            }
                PublishRide[] memory objlist = new PublishRide[](locRideCount);
                PublishRide memory obj;
                uint objindex = 0;
                index = 0;
                while(index < rideindex){
                     if((keccak256(abi.encodePacked(publishRideList[index].headingfrom)) == keccak256(abi.encodePacked(headingfrom)) ||
               keccak256(abi.encodePacked(publishRideList[index].headingto)) == keccak256(abi.encodePacked(headingto))) 
               && publishRideList[index].hashcodeaddress != phashcode) 
               {
                        obj = publishRideList[index];
                        objlist[objindex] = obj;
                        objindex++;
                    }
                    index++;
                }
                return (objlist,locRideCount);
         }

         function searchByDate(address phashcode,string memory ridedate ) view public returns (PublishRide[] memory,uint){
            uint dateRideCount= 0;
            uint index = 0;
            while(index < rideindex){
               if(keccak256(abi.encodePacked(publishRideList[index].ridingdate)) == keccak256(abi.encodePacked(ridedate))
                && publishRideList[index].hashcodeaddress != phashcode) 
               {
                     
                     dateRideCount++;
               } 
                index++;
            }
                PublishRide[] memory objlist = new PublishRide[](dateRideCount);
                PublishRide memory obj;
                uint objindex = 0;
                index = 0;
                while(index < rideindex){
                     if(keccak256(abi.encodePacked(publishRideList[index].ridingdate)) == keccak256(abi.encodePacked(ridedate))
                      && publishRideList[index].hashcodeaddress != phashcode){
                        obj = publishRideList[index];
                        objlist[objindex] = obj;
                        objindex++;
                    }
                    index++;
                }
                return (objlist,dateRideCount);
         }

        function searchByVehicle(address phashcode,string memory vtype ) view public returns (PublishRide[] memory,uint){
            uint vtypeRideCount= 0;
            uint index = 0;
            while(index < rideindex){
               if(keccak256(abi.encodePacked(publishRideList[index].vtype)) == keccak256(abi.encodePacked(vtype))
                && publishRideList[index].hashcodeaddress != phashcode){
                     
                     vtypeRideCount++;
               } 
                index++;
            }
                PublishRide[] memory objlist = new PublishRide[](vtypeRideCount);
                PublishRide memory obj;
                uint objindex = 0;
                index = 0;
                while(index < rideindex){
                     if(keccak256(abi.encodePacked(publishRideList[index].vtype)) == keccak256(abi.encodePacked(vtype))
                      && publishRideList[index].hashcodeaddress != phashcode) {
                        obj = publishRideList[index];
                        objlist[objindex] = obj;
                        objindex++;
                    }
                    index++;
                }
                return (objlist,vtypeRideCount);
         }
        /*mapping(uint => RideBooking) public bookingList;
        uint bookingindex;
        uint bookingKey;*/
         function getPassengerBookedRides(address phashcode) view public returns(PublishRideBookingList[] memory,uint)
         {
            uint passengerbookingcount = 0;
            uint index = 0;
            while(index < bookingindex)
            {
                if(bookingList[index].bookedbypassenger == phashcode)
                {
                    passengerbookingcount++;
                }
                index++;
            }
            PublishRideBookingList[] memory bookingobjlist = new PublishRideBookingList[](passengerbookingcount);
            index = 0;
            uint booklistindex = 0;
            while(index < bookingindex)
            {
                if(bookingList[index].bookedbypassenger == phashcode)
                {
                    uint searchindex = bookingList[index].rideKey-1;

                    PublishRide memory probj = publishRideList[searchindex];

                    PublishRideBookingList memory obj = PublishRideBookingList(
                    bookingList[index].rideKey,probj.hashcodeaddress, probj.headingfrom, probj.headingto,
                     probj.ridingdate,probj.ridingtime,  probj.rideamount,probj.nop,
                     probj.nopstatus, probj.vtype,probj.isRideBookingDone,probj.isRideOver,probj.rideStatus,
                     bookingList[index].rideBookingKey,bookingList[index].bookedbypassenger,bookingList[index].travelnop,
                     bookingList[index].paidamount, bookingList[index].bookingstatus, bookingList[index].paymentstatus);
                     bookingobjlist[booklistindex] = obj;
                    booklistindex++;
                }
                index++;
            }
            return (bookingobjlist,booklistindex);

         }

          function getDriverBookedRides(address dhashcode) view public returns(PublishRideBookingList[] memory,uint)
         {
            uint driverbookingcount = 0;
            uint index = 0;
            while(index < rideindex)
            {
                if(publishRideList[index].hashcodeaddress == dhashcode)
                {
                    driverbookingcount++;
                }
                index++;
            }
            PublishRideBookingList[] memory bookingobjlist = new PublishRideBookingList[](driverbookingcount);
            index = 0;
            uint booklistindex = 0;
            while(index < rideindex)
            {
                if(publishRideList[index].hashcodeaddress == dhashcode)
                {
                    uint searchindex = publishRideList[index].rideKey-1;

                    PublishRide memory probj = publishRideList[searchindex];

                    PublishRideBookingList memory obj = PublishRideBookingList(
                    bookingList[index].rideKey,probj.hashcodeaddress, probj.headingfrom, probj.headingto,
                     probj.ridingdate,probj.ridingtime,  probj.rideamount,probj.nop,
                     probj.nopstatus, probj.vtype,probj.isRideBookingDone,probj.isRideOver,probj.rideStatus,
                     bookingList[index].rideBookingKey,bookingList[index].bookedbypassenger,bookingList[index].travelnop,
                     bookingList[index].paidamount, bookingList[index].bookingstatus, bookingList[index].paymentstatus);
                     bookingobjlist[booklistindex] = obj;
                    booklistindex++;
                }
                index++;
            }
            return (bookingobjlist,booklistindex);

         }

         function rideBookingStatusUpdate(uint rbid,uint action) public {
            RideBooking memory obj = bookingList[rbid - 1];
            if(action == 1)
            {
                obj.bookingstatus = true;
            }
            else{
                obj.bookingstatus = false;
            }
            bookingList[rbid - 1] = obj;
         }

        function ridepaymentupdates(uint rbid) public {
            bookingList[rbid - 1].paymentstatus  = true;  
         }

         function updateRideStatus(uint _rideKey, uint newStatus) public {
    require(_rideKey > 0 && _rideKey <= rideindex, "Invalid Ride Key");
    uint index = _rideKey - 1;

    PublishRide storage ride = publishRideList[index];
    require(msg.sender == ride.hashcodeaddress, "Only ride owner can update status");

    require(newStatus >= 1 && newStatus <= 3, "Invalid status");

    if (newStatus == 1) {
        ride.rideStatus = true; // Active
    } else if (newStatus == 2) {
        ride.isRideOver = true; // Completed
    } else if (newStatus == 3) {
        ride.rideStatus = false; // Cancelled
    }

    publishRideList[index] = ride;
}
}