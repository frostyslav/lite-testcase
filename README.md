# lite-testcase

## Test
1. Docker-ayes: Write a Dockerfile to run Litecoin 0.18.1 in a container. It should somehow verify the
checksum of the downloaded release (there's no need to build the project), run as a normal user, and
when run without any modifiers (i.e. docker run somerepo/litecoin:0.18.1) should run the daemon, and
print its output to the console. The build should be security conscious (and ideally pass a container
image security test such as Anchore). [20 pts]
2. k8s FTW: Write a Kubernetes StatefulSet to run the above, using persistent volume claims and
resource limits. [15 pts]
3. All the continuouses: Write a simple build and deployment pipeline for the above using groovy /
Jenkinsfile, Travis CI or Gitlab CI. [15 pts]
4. Script kiddies: Source or come up with a text manipulation problem and solve it with at least two of
awk, sed, tr and / or grep. Check the question below first though, maybe. [10pts]
5. Script grown-ups: Solve the problem in question 4 using any programming language you like. [15pts]
6. Terraform lovers unite: write a Terraform module that creates the following resources in IAM;
- A role, with no permissions, which can be assumed by users within the same account,
- A policy, allowing users / entities to assume the above role,
- A group, with the above policy attached,
- A user, belonging to the above group.

All four entities should have the same name, or be similarly named in some meaningful way given the context e.g. prod-ci-role, prod-ci-policy, prod-ci-group, prod-ci-user; or just prod-ci. Make the suffixes toggleable, if you like. [25pts]


## Implementation

1. Dockerfile was taken from https://github.com/uphold/docker-litecoin-core/
Introduced changes:
- Fix the gpg key download
- Update gosu version
- Convert to multi-stage build
- Switch to fedora to fix vulnerabilities
- Fix docker-entrypoint.sh


2. Kubernetes chart was generated using `helm create` and updated to use statefulset

3. Jenkinsfile is created in declarative style. Resources used:
- Plugin https://plugins.jenkins.io/docker-workflow/
- Parts of code https://medium.com/swlh/jenkins-pipeline-to-create-docker-image-and-push-to-docker-hub-721919512f2

4. List security warnings (it is pointless to do it like this, but it is a text manipulation):
```
bash ./scripts/list-security-warnings.sh
```

5. List security warnings (python + json):
```
python3 ./scripts/list-security-warnings.py --image litecoin:0.18.1
```
