import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import DEADLINE_FIELD from '@salesforce/schema/Travel_Allowance__c.Manager_Approval_Deadline__c';

const FIELDS = [DEADLINE_FIELD];

export default class ApprovalCountDown extends LightningElement {
    @api recordId;
    deadline;
    timeRemaining;
    expired = false;
    intervalId;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredRecord({ error, data }) {
        if (data) {
            this.deadline = new Date(data.fields.Manager_Approval_Deadline__c.value);
            this.startCountdown();
        } else if (error) {
            console.error('Error loading record:', error);
        }
    }

     get progressVariant() {
        return this.expired ? 'warning' : 'base-autocomplete';
    }

    startCountdown() {
        this.updateTimeRemaining(); // Initial call

        this.intervalId = setInterval(() => {
            this.updateTimeRemaining();
        }, 1000); // Update every second
    }

    updateTimeRemaining() {
        const now = new Date();
        const diff = this.deadline - now;

        if (diff <= 0) {
            this.expired = true;
            this.timeRemaining = null;
            clearInterval(this.intervalId);
        } else {
            this.expired = false;
            const days = Math.floor(diff / (1000 * 60 * 60 * 24));
            const hours = Math.floor((diff / (1000 * 60 * 60)) % 24);
            const minutes = Math.floor((diff / (1000 * 60)) % 60);
            const seconds = Math.floor((diff / 1000) % 60);

            this.timeRemaining = `${days}d ${hours}h ${minutes}m ${seconds}s`;
        }
    }

    disconnectedCallback() {
        clearInterval(this.intervalId);
    }
}
