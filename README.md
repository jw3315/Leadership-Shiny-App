# Leadership-Shiny-App

1.	Leadership Shiny App: https://jiawang.shinyapps.io/leadershippotentialmodel/

Managers evaluate employees on 8 orientations by selecting on the left side panel.
On the main panel of the page: 
Level of Competence table shows the employee’s score on 8 performance orientations.
Score of Leadership table indicates the employee’s 5 leadership personalities.
Leadership Potential score is a comprehensive score for this employee.

2.	Leadership Solver

On the “Simulation” sheet, managers evaluate employees on 8 orientations by inserting scores in the green part. Press “Ctrl+Shift+L” to trigger a Macro that does the calculations.
The pink leadership predictors part shows 5 leadership personalities.
The blue part is the predicted performance orientation score.
The red column is the final comprehensive leadership potential score.

Interpretation

Use the Shiny app (the solver basically does the same work) for example

•	A typical qualified employee scoring 3 on every orientations have a final leadership potential score 3. 

•	If someone shows a better performance on result orientation, like “exceeds goals”, we see him/her having a higher motivation, then results in a higher leadership potential score. 

•	If someone is even better on results orientation “improves bank’s practices and performance”. Even realLOC is [5,3,3,3,3,3,3,3], we see a higher predicted level of competence “predLOC”. We believe he/she must have a potential to be better on several other orientations. Also, this employee has more motivation and curiosity. Obviously, a higher final leadership score.

Model Explanation

1.	Model's objective: find employee's leadership potential.
We are going to find the solution: what makes an employee have a high level or a low level of competence. For instance, employee A has a low level of competence on result orientation metrics, is it because A is not motivated, or A is not good at determination?) 

2.	Model type: optimized solution model 

3.	Model: (use the excel to explain)

•	Input: 

o	realLOC: Employee's level of competence (It is a 1-7 scoring system on 8 orientations. It could be scored by the employee's manager)

o	W: Weight (Weight for 5 leadership predictors to predict 8 kinds of level of competence)

o	P: 5 leadership predictors

•	Process:

o	Employee's predicted level of competence: predLOC = P * W

o	Difference between predicted LOC and real LOC: diff = predLOC - realLOC

o	To minimize sum(squared diff for every orientation), find non-negtive solution of P as P* ( constraint: P>=0, diff>=0)

o	leadership potential score = 10%*motivation+15%*curiosity+20%*Insight+25%*Engagement+30%*Determination.

** Thanks Martha Underwood for the initial and main idea of this leadership potential model.
