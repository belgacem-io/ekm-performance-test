# Values for gitlab/gitlab chart on GKE
global:
  edition: ce

  serviceAccount:
    enabled: true
    name: ${KSA}
    create: false

  hosts:
    domain: ${DOMAIN}
    https: false
    ssh: ~

  kubectl:
    image:
      repository: ${region}-docker.pkg.dev/${project_id}/${repository_gitlab_id}/gitlab-org/build/cng/kubectl
      tag: v16.3.4

  gitlabBase:
    image:
      repository: ${region}-docker.pkg.dev/${project_id}/${repository_gitlab_id}/gitlab-org/build/cng/gitlab-base
      tag: v16.3.4

  certificates:
    image:
      repository: ${region}-docker.pkg.dev/${project_id}/${repository_gitlab_id}/gitlab-org/build/cng/certificates
      tag: v16.3.4

  gitaly:
    enabled: true

  ## doc/charts/globals.md#configure-ingress-settings
  ingress:
    enabled: false
    configureCertmanager: false
    tls:
      enabled: false

  psql:
    password:
      secret: ${DB_PWD_SECRET_NAME}
      key: password
    host: ${DB_PRIVATE_IP}
    port: 5432
    username: ${DB_USERNAME}
    database: ${DB_NAME}
  
  ## doc/charts/globals.md#configure-appconfig-settings
  ## Rails based portions of this chart share many settings
  appConfig:
    ## doc/charts/globals.md#general-application-settings
    enableUsagePing: false

    ## doc/charts/globals.md#lfs-artifacts-uploads-packages
    backups:
      bucket: ${BUCKET_NAME_BACKUP}
    lfs:
      bucket: ${BUCKET_NAME_LFS}
    artifacts:
      bucket: ${BUCKET_NAME_ARTIFACTS}
    uploads:
      bucket: ${BUCKET_NAME_UPLOADS}
    packages:
      bucket: ${BUCKET_NAME_PACKAGE}
    pseudonymizer:
      bucket: ${BUCKET_NAME_PSEUDONYMIZER}

gitlab:
  gitaly:
    image:
      repository: ${region}-docker.pkg.dev/${project_id}/${repository_gitlab_id}/gitlab-org/build/cng/gitaly
      tag: v16.3.4
  gitlab-exporter:
    image:
      repository: ${region}-docker.pkg.dev/${project_id}/${repository_gitlab_id}/gitlab-org/build/cng/gitlab-exporter
      tag: 13.2.0
  gitlab-shell:
    image:
      repository: ${region}-docker.pkg.dev/${project_id}/${repository_gitlab_id}/gitlab-org/build/cng/gitlab-shell
      tag: v14.26.0 
  kas:
    image:
      repository: ${region}-docker.pkg.dev/${project_id}/${repository_gitlab_id}/gitlab-org/build/cng/gitlab-kas
      tag: v16.3.0
  migrations:
    image:
      repository: ${region}-docker.pkg.dev/${project_id}/${repository_gitlab_id}/gitlab-org/build/cng/gitlab-toolbox-ce
      tag: v16.3.4
    resources:
      requests:
        cpu: 500m
        memory: 2000Mi
  toolbox:
    image:
      repository: ${region}-docker.pkg.dev/${project_id}/${repository_gitlab_id}/gitlab-org/build/cng/gitlab-toolbox-ce
      tag: v16.3.4
  webservice: 
    image:
      repository: ${region}-docker.pkg.dev/${project_id}/${repository_gitlab_id}/gitlab-org/build/cng/gitlab-webservice-ce
      tag: v16.3.4
    workhorse:
      image: ${region}-docker.pkg.dev/${project_id}/${repository_gitlab_id}/gitlab-org/build/cng/gitlab-workhorse-ce
      tag: v16.3.4
  sidekiq: 
    image:
      repository: ${region}-docker.pkg.dev/${project_id}/${repository_gitlab_id}/gitlab-org/build/cng/gitlab-sidekiq-ce
      tag: v16.3.4

registry:
  image:
    repository: ${region}-docker.pkg.dev/${project_id}/${repository_gitlab_id}/gitlab-org/build/cng/gitlab-container-registry
    tag: v3.79.0-gitlab

gitlab-runner:
  install: true
  image:
    registry: ${region}-docker.pkg.dev/${project_id}/${repository_gitlab_id}
    repository: gitlab-runner
    tag: alpine-v16.2.0 
  gitlabUrl: http://${NAME}-webservice-default:8181
  concurrent: 10
  logLevel: info
  logFormat: json
  runners:
    locked: false
    cache:
      cacheType: gcs
      gcsBucketName: ${BUCKET_NAME_RUNNER}
      cacheShared: true

prometheus:
  install: false

redis:
  install: true
  image:
    registry: ${region}-docker.pkg.dev/${project_id}/${repository_dockerhub_id}
    repository: bitnami/redis
    tag: 6.2.7-debian-11-r11
  metrics:
    image:
      registry: ${region}-docker.pkg.dev/${project_id}/${repository_dockerhub_id}
      repository: bitnami/redis-exporter
      tag: 1.43.0-debian-11-r4

postgresql:
  install: false

certmanager:
  install: false

nginx-ingress:
  enabled: false

shared-secrets:
  enabled: true
  rbac:
    create: true
  selfsign:
    image:
      repository: ${region}-docker.pkg.dev/${project_id}/${repository_gitlab_id}/gitlab-org/build/cng/cfssl-self-sign
      tag: v16.3.4

minio:
  install: false