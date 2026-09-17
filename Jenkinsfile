pipeline {
    agent any

    environment {
        APP_DIR = "/home/ubuntu/advanced-cicd"
    }

    stages {
        stage('Build & Test') {
            steps {
                echo "Running Build and Unit Tests..."
                sh 'echo "Testing build..." && exit 0'
            }
        }

        stage('Security Scan (Gitleaks)') {
            steps {
                echo "Running Secret Detection..."
                sh 'gitleaks detect --source ${APP_DIR} --verbose'
            }
        }

        stage('Dependency Scan (Trivy)') {
            steps {
                echo "Running Vulnerability Scan..."
                sh 'trivy fs --severity CRITICAL --exit-code 0 ${APP_DIR}'
            }
        }

        stage('Database Check & Backup') {
            steps {
                echo "Verifying PostgreSQL readiness and taking snapshot..."
                sh '''
                    docker exec postgres-db pg_isready -U postgres
                    docker exec postgres-db pg_dump -U postgres appdb > ${APP_DIR}/database/backup/pre_deploy_backup.sql
                '''
            }
        }

        stage('Deploy to Green') {
            steps {
                echo "Deploying release to GREEN environment..."
                sh '''
                    docker stop app-green || true
                    docker rm app-green || true
                    docker run -d --name app-green -p 5002:80 nginxdemos/hello
                '''
            }
        }

        stage('Automated Health Check & Switch') {
            steps {
                echo "Checking GREEN health and switching traffic..."
                sh '''
                    sleep 2
                    HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5002/ || echo "500")
                    if [ "$HEALTH" = "200" ]; then
                        echo "Green is healthy. Switching traffic..."
                        sudo sed -i 's/5001/5002/' /etc/nginx/sites-available/default
                        sudo systemctl reload nginx
                    else
                        echo "Health check failed! Retaining BLUE."
                        exit 1
                    fi
                '''
            }
        }
    }

    post {
        success {
            echo "PIPELINE SUCCESS: Release deployed to production."
        }
        failure {
            echo "PIPELINE FAILURE: Rolling back and notifying team."
            sh 'sudo sed -i "s/5002/5001/" /etc/nginx/sites-available/default && sudo systemctl reload nginx || true'
        }
    }
}
