import * as dedent from 'dedent-js';
import { Construct } from "constructs";
import { App, CheckoutJob, Stack, Workflow } from "cdkactions";

export class MyStack extends Stack {
  constructor(scope: Construct, name: string) {
    super(scope, name);

    const workflow = new Workflow(this, "lint-tf", {
      name: "Lint Terraform",
      on: {
        push: {
          paths: ["terraform/**"]
        }
      },
    })

    new CheckoutJob(workflow, 'lint-tf', {
      runsOn: 'ubuntu-latest',
      steps: [
        {
          name: 'Lint Terraform',
          run: dedent`cd terraform
          terraform fmt -check`,
        }],
    });

  }
}

const app = new App();
new MyStack(app, 'cdk');
app.synth();
