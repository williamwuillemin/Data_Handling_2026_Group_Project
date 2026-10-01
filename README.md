# Data Handling – Group Project (HSG, Fall 2026)

## ⏰ Key deadlines
| Date | What |
|---|---|
| **22 Oct 2026** | Project brief released + **deadline to register the group (5 students) on Canvas** |
| **12 Nov 2026** | Q&A session on the group project (in the lecture) |
| **16 Dec 2026, 23:59** | **Final submission** |
| **17 Dec 2026** | Exam – includes MC and essay questions **on this project** |

## About the project
Group written project for *Data Handling: Import, Cleaning and Visualisation* (BEcon 3230, Dr. Aurélien Sallin).
Worth **50 % of the grade**. We work with **real-world data** and go through the full data pipeline in **R**:

gather/collect → clean → store → retrieve → analyze → visualize → communicate

The exam tests our understanding of the project, so **every member should understand all parts of the code**, not only their own.

Detailed requirements will be added here once the brief is published (22 Oct).

## Team
| Name | GitHub | Email (GitHub account) |
|---|---|---|
| William | @williamwuillemin | william.wuillemin04@gmail.com |
| ... | @... | ... |

## How we work (rules)

> [!NOTE]
> `main` is protected: changes only reach it through a **Pull Request approved by a teammate**. Direct pushes, force pushes and deleting `main` are blocked by GitHub.

1. **Pull first:** `git checkout main` then `git pull`, so you start from the latest version.
2. **Work on your own branch:** `git checkout -b yourname/topic` (e.g. `william/data-cleaning`).
3. **Push and open a Pull Request:** `git push -u origin yourname/topic`, then click *Compare & pull request* on GitHub.
4. **Get 1 approval:** a teammate reviews the *Files changed* tab and approves. You can't approve your own PR.
5. **New commits reset the approval:** if you change the code after an approval, ask for a new review.
6. **Resolve all comments:** every review comment must be marked *Resolved* before merging.
7. **Merge**, then everyone runs `git pull` on `main`.

Don't commit large raw data files or passwords/API keys (see `.gitignore`).
