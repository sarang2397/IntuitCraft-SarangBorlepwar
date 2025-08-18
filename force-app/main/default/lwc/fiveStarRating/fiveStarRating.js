
import { LightningElement, api } from 'lwc';
import fivestar from '@salesforce/resourceUrl/fivestar';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const TOAST_ERROR_TITLE = 'Error loading five-star';
const ERROR_VARIANT = 'error';
const EDITABLE_CLASS = 'c-rating';
const READ_ONLY_CLASS = 'readonly c-rating';
export default class FiveStarRating extends LightningElement {

  @api readOnly;
  @api value;

  editedValue;
  isRendered;

  get starClass() {
    return this.readOnly?READ_ONLY_CLASS:EDITABLE_CLASS;
  }

  // Render callback to load the script once the component renders.
  renderedCallback() {
    if (this.isRendered) {
      return;
    }
    this.loadScript();
    this.isRendered = true;
  }

  loadScript() {
    Promise.all([
      loadStyle(this, fivestar + '/rating.css'),
      loadScript(this, fivestar + '/rating.js')
    ]).then(() => {
      this.initializeRating();
    }).catch((error)=>{
      this.dispatchEvent(new ShowToastEvent({
          title: TOAST_ERROR_TITLE,
          message: JSON.stringify(error),
          variant: ERROR_VARIANT
      }));
    }).
    finally(()=>{
      
    })
  }

  initializeRating() {
    let domEl = this.template.querySelector('ul');
    let maxRating = 5;
    let callback = (rating) => {
      this.editedValue = rating;
      this.ratingChanged(rating);
    };
    this.ratingObj = window.rating(
      domEl,
      this.value,
      maxRating,
      callback,
      this.readOnly
    );
  }

  ratingChanged(rating) {
    const CURRENT_RATING = rating;
    const ratingchangeEvent = new CustomEvent('ratingchange', {
        detail: { 
            rating: CURRENT_RATING 
        }
    });
    this.dispatchEvent(ratingchangeEvent);
  }
}
