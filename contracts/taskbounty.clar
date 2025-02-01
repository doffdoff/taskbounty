;; TaskBounty: A simple smart contract for posting tasks with bounties and claiming them.

(define-map tasks uint
            {poster: principal,
             description: (string-ascii 200),
             bounty: uint,
             is-claimed: bool})

(define-data-var task-counter uint u0)

(define-public (create-task (description (string-ascii 200)) (bounty uint))
    (begin
        (asserts! (> bounty u0) (err u1004)) ;; Error: Bounty must be greater than zero
        (asserts! (is-eq (len description) (len description)) (err u1005)) ;; Check description validity
        (let ((transfer-result (try! (stx-transfer? bounty tx-sender (as-contract tx-sender))))
              (task-id (var-get task-counter)))
            ;; transfer-result is already handled by try!
            (if (map-insert tasks task-id 
                {poster: tx-sender, description: description, bounty: bounty, is-claimed: false})
                (begin
                    (var-set task-counter (+ task-id u1))
                    (ok task-id))
                (err u1003))))) ;; Error: Failed to insert task

(define-public (claim-task (task-id uint))
    (begin
        (let ((task (map-get? tasks task-id)))
            (match task
                task-data
                    (if (not (get is-claimed task-data))
                        (if (is-eq tx-sender (get poster task-data))
                            (err u1000) ;; Prevent posters from claiming their own tasks
                            (begin
                                (try! (as-contract (stx-transfer? (get bounty task-data) tx-sender tx-sender)))
                                (asserts! (<= task-id (var-get task-counter)) (err u1002))
                                (map-set tasks task-id 
                                    {poster: (get poster task-data),
                                     description: (get description task-data),
                                     bounty: (get bounty task-data),
                                     is-claimed: true})
                                (ok (get bounty task-data))))
                        (err u1001)) ;; Error: Task already claimed
                (err u1002))))) ;; Error: Task not found

(define-public (get-task (task-id uint))
    (begin
        (let ((task (map-get? tasks task-id)))
            (match task
                task-data (ok task-data)
                (err u1002))))) ;; Error: Task not found