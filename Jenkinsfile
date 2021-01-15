/*
 * Copyright (c) 2019-present Sonatype, Inc. All rights reserved.
 * Includes the third-party code listed at http://links.sonatype.com/products/nexus/attributions.
 * "Sonatype" is a trademark of Sonatype, Inc.
 */
@Library(['private-pipeline-library', 'jenkins-shared', 'int-jenkins-shared', 'iqAzureDevops-pipeline-library']) _

dockerizedBuildPipeline(
  prepare: {
    githubStatusUpdate('pending')
  },

  buildAndTest: {
    sh './build.sh'
  },

  skipVulnerabilityScan: true,

  vulnerabilityScan: {
    final stage = isDeployBranch(env, 'master') ? 'build' : 'develop'

    nexusPolicyEvaluation
        iqStage: stage,
        iqApplication: 'helm3-charts',
        iqScanPatterns: [[scanPattern: '**/*']],
        failBuildOnNetworkError: true
  },

  archiveArtifacts: 'docs/*',
  testResults: [],

  onSuccess: {
    buildNotifications(currentBuild, env, 'master')
  },

  onFailure: {
    buildNotifications(currentBuild, env, 'master')
  }
)
