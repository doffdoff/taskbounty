# TaskBounty

TaskBounty is a Clarity smart contract for the Stacks blockchain that enables users to post tasks with bounties and allows others to claim them.

## Features
- **Task Creation:** Users can post tasks with a description and a bounty.
- **Task Claiming:** Other users can claim tasks and receive the bounty.
- **Task Retrieval:** Fetch details of any task using its ID.

## Smart Contract Functions

### `create-task`
- **Params:**  
  - `description (string-ascii 200)`: A brief description of the task.
  - `bounty (uint)`: The reward amount for completing the task.
- **Returns:** `task-id (uint)` on success or an error code.

### `claim-task`
- **Params:**  
  - `task-id (uint)`: The ID of the task to claim.
- **Returns:** The bounty amount on success or an error code.
- **Restrictions:**  
  - Task creators cannot claim their own tasks.
  - Tasks can only be claimed once.

### `get-task`
- **Params:**  
  - `task-id (uint)`: The ID of the task.
- **Returns:** The task details or an error if not found.

## Error Codes
- `u1000`: Task creators cannot claim their own tasks.
- `u1001`: Task already claimed.
- `u1002`: Task not found.
- `u1003`: Failed to insert task.
- `u1004`: Bounty must be greater than zero.

## Deployment & Usage
To deploy and interact with the contract, use the Stacks CLI:

1. **Deploy the contract**
   ```sh
   clarinet contract deploy TaskBounty
   ```
2. **Create a task**
   ```sh
   clarinet contract-call TaskBounty create-task "Complete the design" u100
   ```
3. **Claim a task**
   ```sh
   clarinet contract-call TaskBounty claim-task u0
   ```
4. **Get task details**
   ```sh
   clarinet contract-call TaskBounty get-task u0
   ```