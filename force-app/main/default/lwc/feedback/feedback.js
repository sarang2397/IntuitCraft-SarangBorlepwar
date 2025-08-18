import { LightningElement } from 'lwc';
import submitFeedback from '@salesforce/apex/HotelController.submitFeedback';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class Feedback extends LightningElement {
    isOpen=true;
    clarityRating;
    timelinessRating;
    communicationRating;
    overallRating;
    comments;

    handleRatingChanged(event){
        let currentName=event.currentTarget.dataset.name;
        let rating = event.detail.rating;

        if(currentName=='clarity'){
           this.clarityRating=rating;
        }
        if(currentName=='timeliness'){
            this.timelinessRating=rating;
        }
        if(currentName=='communication'){
            this.communicationRating=rating;
        }
        if(currentName=='overall'){
            this.overallRating=rating;
        }
    }
    closeModal(){
        this.isOpen=false;
    }

    handleCommentsChange(event){
        this.comments=event.target.value;

    }

    submitFeedback(event) {
        submitFeedback({
            clarityRating: this.clarityRating,
            timelinessRating: this.timelinessRating,
            communicationRating: this.communicationRating,
            overallRating: this.overallRating,
            comments: this.comments
        })
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Thank you for your feedback!',
                    variant: 'success'
                })
            );
            this.closeModal();
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: error,
                    variant: 'error'
                })
            );
        });
    }
}