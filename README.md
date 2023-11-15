# ekm-performance-test



### Run EKM performance tests on Google Cloud
1. Clone the repo
   ```sh
   git clone https://github.com/belgacem-io/ekm-performance-test.git
   ```

2. Create '.env/gcp.env'
   ```sh
   # GCP project where all resources will be created
   export PROJECT_ID=xx-myproject-test-xxx
   # Service account email used for creating resources                           
   export GCP_IAC_SERVICE_ACCOUNT=xx@xx-myproject-test-xxx.iam.gserviceaccount.com        
   # Default region where resources will be created
   export GCP_REGION=xxxxx
   # KMS Key URL used for encryption                         
   export GCP_KMS_KEY_URL=https://xxxxxxx                       
   ```

3. Load env variables
   ```sh
    source .env/gcp.env                     
   ```

4. Authenticate to google cloud
   ```sh
    gcloud auth application-default login --no-launch-browser
    gcloud config set project $PROJECT_ID
   ```

5. Create and configure required resources
   ```sh
    terragrunt --terragrunt-working-dir terragrunt/gcp run-all apply
   ```

6. Connect to bastion host using IAP tunneling
   ```sh
    INSTANCE_NAME=$(gcloud --project=$PROJECT_ID  compute instances list --format="value(name)")
    gcloud --project=$PROJECT_ID  compute ssh ${INSTANCE_NAME}
   ```
7. Install required tools
   ```sh
    sudo bash /etc/test/run_perf_tests.sh --install
   ```

8. Run tests against the database encrypted with KMS key
   ```sh
    sudo bash /etc/test/run_perf_tests.sh --kms
   ```

9. Run tests against the database encrypted with EKM key
   ```sh
    sudo bash /etc/test/run_perf_tests.sh --ekm
   ```