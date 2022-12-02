locals {
  // Name of the homework mapped to published status
  published = {
    hw0           = true
    hw1           = true
    hw2           = true
    hw3           = true
    hw4           = true
    final_project = true
  }
  // Create a list of objects representing all homework repos to be (eventually) created. 
  hws = flatten([
    for hw, published in local.published : [
      for user, _ in local.users : {
        hw = hw, student = user, published = published
      }
    ]
  ])
  bot_user         = "cis188bot"
  k8s_cluster_name = "cis188"
  users            = merge(var.students, var.instructors, var.tas)
}
