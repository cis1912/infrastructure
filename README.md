# infrastructure

This repo contains the underlying infrastructure of CIS 188. Feel free to poke around! If you want to learn more about how anything is configured just ask.

## Beginning of semester configuration

First, make sure all of the hws are unpublished in `terraform/main.tf` and that you have set the `students` variable (Most likely by using the `TF_VAR_students` environment variable in the form `TF_VAR_students='["pennkey1","pennkey2"]'`).

1. Run `terraform apply` within the `terraform` folder. This will create all the course infrastructure needed.
2. On GitHub, manually invite students to the team named after their pennkey.

NOTE: Running `terraform apply` will ask for the following variables:
- `GF_GH_CLIENT_ID`
- `GF_GH_CLIENT_SECRET` 
- `image_pull_pat`
- `instructors`
They are provided by a `terraform.tfvars` file, and should be updated on a semester basis.
## Releasing a homework assignment

1. Make sure any changes that need to be made to the homework are finalized.
2. Within `terraform/main.tf`, for the `published` local change `false` to `true` for the homework that you want to release
3. Run `terraform apply`

## End of semester teardown

Make sure students know that their homework repos will be deleted at the end of the semester. Suggest using a private repo if they want to save any work from the course.

Make sure all homework assignments are marked as unpublished in `terraform/main.tf` and that your students variable is an empty set then run:

```bash
terraform apply
```
