import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import searchHotelAPI from '@salesforce/label/c.searchHotelAPI'; 


export default class SearchHotels extends LightningElement {
    @track searchKey = '';
    @track checkInDate = '';
    @track checkOutDate = '';
    @track numAdults = 1;
    @track roomQuantity = 1;
    @track suggestions = [];
    submitdisabled=true;
    lat;
    long;
    displayHotels = false;


   handleInputChange(event) {
        this.displayHotels=false;
        this.submitdisabled=false;
        const { name, value } = event.target;
        this[name] = value;
         if (name === 'searchKey') {
            if (value.length > 2) {
                this.fetchSuggestions(value);
            } else {
                this.suggestions = [];
            }
        }
        this.validateFields();

       
    }

    get today() {
        const today = new Date();
        return today.toISOString().split('T')[0];
    }
    

    validateFields(name,value){
        let valid = true;
        const todayStr = this.today;
        // Check required fields
        if (!this.searchKey || this.searchKey.trim().length === 0) valid = false;
        if (!this.checkInDate) valid = false;
        if (!this.checkOutDate) valid = false;
        if (!this.numAdults || isNaN(this.numAdults) || Number(this.numAdults) < 1) valid = false;
        if (!this.roomQuantity || isNaN(this.roomQuantity) || Number(this.roomQuantity) < 1) valid = false;

         // Check that dates are not in the past
        if (this.checkInDate && this.checkInDate < todayStr) valid = false;
        if (this.checkOutDate && this.checkOutDate < todayStr) valid = false;

        //check that checkOutDate is after checkInDate
        if (this.checkInDate && this.checkOutDate && this.checkOutDate < this.checkInDate) {
            valid = false;
            this.showToast('Check-Out Date must be later than Check-In Date.', 'Error', 'error');
        }
        this.submitdisabled = !valid;

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

    handleSearchClick(){
        this.displayHotels=true;
    }

    fetchSuggestions(query) {
        const encodedQuery = encodeURIComponent(query);
        const url = `${searchHotelAPI}${encodedQuery}&format=json&limit=5&accept-language=en`;

        fetch(url, {
            headers: {
                'Accept': 'application/json',
                'Accept-Language': 'en'
            }
        })
        .then(response => response.json())
        .then(data => {
            this.suggestions = data;
            ('suggestions: '+JSON.stringify(this.suggestions));
        })
        .catch(error => {
            console.error('Error fetching suggestions:', error);
            this.suggestions = [];
        });
    }

    handleCitySelect(event) {
        const selectedName = event.currentTarget.dataset.name;
        this.searchKey = selectedName;
        this.lat=event.currentTarget.dataset.lat;
        this.long=event.currentTarget.dataset.long;

        this.suggestions = [];
    }
}








