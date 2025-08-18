import { LightningElement,track,api } from 'lwc';
import getNearbyHotels from '@salesforce/apex/HotelController.getNearbyHotels';
import getHotelOffers from '@salesforce/apex/HotelController.getHotelOffers';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import hasRecentFeedback from '@salesforce/apex/HotelController.hasRecentFeedback';

export default class DisplayHotels extends LightningElement {
    @api lat;
    @api long;
    @api checkInDate = '';
    @api checkOutDate = '';
    @api numAdults = 1;
    @api roomQuantity = 1;
    @track hotels;
    @track hotelOfferData;
    @track offers = [];
    @track error;
    @track loading = true;
    isOpen = false;
    hotelId;
    hotelName;
    showRoomInfo=false;
    heading='Room Info'
    showCreditCardInfo=false;
    hasGivenFeedback = true;

    connectedCallback() {
        this.fetchHotels();
        
    }

    fetchRecentFeedback(){
        hasRecentFeedback()
            .then(result => {
                this.hasGivenFeedback = result;
            })
            .catch(error => {
                this.hasGivenFeedback = false;
                this.showToast(
                    error.body && error.body.message ? error.body.message : 'An unexpected error occurred',
                    'error',
                    'Error'
                )
            });
    }
    

    fetchHotels() {
        this.loading = true;
        getNearbyHotels({lat:this.lat,lon: this.long})
            .then(result => {
                this.hotels = result;
                this.error = null;
            })
            .catch(error => {
                this.error = error;
                this.hotels = null;
                this.showToast(
                    error.body && error.body.message ? error.body.message : 'An unexpected error occurred',
                    'error',
                    'Error'
                )
            })
            .finally(() => {
                this.loading = false;
            });
    }

    handleBookNow(event) {
        this.hotelId = event.currentTarget.dataset.hotelid;
        this.hotelId='mock';

        this.fetchHotelOffers();
       
    
    }

    // ...existing code...

    handleBook() {
        let isValid = true;
        this.template.querySelectorAll('lightning-input').forEach(input => {
            if (
                this.showCreditCardInfo &&
                input.name &&
                ['cardNumber', 'cardHolder', 'expiry', 'cvv'].includes(input.name)
            ) {
                input.reportValidity();
                // Check for blank value or invalid pattern
                if (!input.value || !input.checkValidity()) {
                    isValid = false;
                }
            }
        });

        if (isValid) {
            this.showToast('Booking successful!','success','Success');
            this.closeModal();

            //Logic For User Feedback
            this.fetchRecentFeedback();
        } else {
            this.showToast('Please Validate All Credit Card Info','error','Error');
        }
    }

    closeModal() {
       this.isOpen=false;
    }

    handleBookHotel(event){
        console.log(event.target.dataset.name);
        this.showRoomInfo=false;
        this.heading='Credit/Debit Card Information';
        this.showCreditCardInfo=true;

    }

    fetchHotelOffers(){
         this.loading = true;
        getHotelOffers({hotelId:this.hotelId,checkInDate:this.checkInDate,checkOutDate:this.checkOutDate,roomQuantity:this.roomQuantity,noOfAdults:this.noOfAdults})
            .then(result => {
                this.hotelOfferData = result;
                this.error = null;
                this.isOpen=true;
                this.showRoomInfo=true;
                this.showCreditCardInfo=false;
                this.heading='Room Info';

                if (this.hotelOfferData && this.hotelOfferData.data?.length > 0) {
                    const hotelEntry = this.hotelOfferData.data[0];
                    this.hotelName = hotelEntry.hotel.name;

                    this.offers = hotelEntry.offers.map(offer => {
                        return {
                            id: offer.id,
                            roomType: offer.room.type || 'N/A',
                            category: offer.room.typeEstimated?.category || 'N/A',
                            bedType: offer.room.typeEstimated?.bedType || 'N/A',
                            checkIn: offer.checkInDate,
                            checkOut: offer.checkOutDate,
                            price: offer.price?.total || 'N/A',
                            currency: offer.price?.currency || '',
                            rateCode: offer.rateCode || '',
                            cancellationPolicy: offer.policies?.cancellation?.description?.text || 'Not specified',
                            description: offer.room.description?.text || 'No description available'
                        };
                    });
                }
            })
            .catch(error => {
                this.hotelOfferData = null;
                this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error.body && error.body.message ? error.body.message : 'An unexpected error occurred',
                    variant: 'error'
                })
            );
            })
            .finally(() => {
                this.loading = false;
            });
    }

     showToast(message,variant,title){
        const evt = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
        mode: 'dismissable'
    });
    this.dispatchEvent(evt);
    }

}