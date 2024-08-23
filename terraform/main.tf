locals {
  // Name of the homework mapped to published status
  published = {
    hw0           = false
    hw1           = false
    hw2           = false
    hw3           = false
    hw4           = false
    final_project = false
  }
  // Create a list of objects representing all homework repos to be (eventually) created. 
  hws = flatten([
    for hw, published in local.published : [
      for user, _ in local.users : {
        hw = hw, student = user, published = published
      }
    ]
  ])
  bot_user         = "cis1912bot"
  k8s_cluster_name = "cis1912"
  users            = merge(var.students, var.instructors, var.tas)
}
