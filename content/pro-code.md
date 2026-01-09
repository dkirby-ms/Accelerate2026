# Pro-Code Challenge (90 Minutes)

## Objective
Evolve an AI-generated prototype into a **deployable Azure application** that demonstrates real engineering judgment — not just a demo.

This phase is intentionally time-boxed. Teams are expected to deliver a **credible vertical slice**, not a full product.

---

## What “Done” Looks Like in 90 Minutes

### 1. Working Vertical Slice
- A minimal **frontend + backend** flow
- At least **one real user interaction**
- No stubbed or fake logic in the demo path

> Think: one end-to-end scenario that actually works.

---

### 2. AI-Accelerated, Engineer-Directed
Teams are encouraged to use AI tools such as:
- **GitHub Copilot**
- **Spec Kit** (or similar tools)

AI may be used to:
- Scaffold UI and APIs
- Replace prototype logic with real implementations
- Accelerate boilerplate and iteration

> AI helps you go faster — **engineers decide what ships**.

---

### 3. Authentication with Microsoft Entra (Required)
- Users authenticate using **Microsoft Entra ID**
- Backend APIs are secured (e.g., OAuth / JWT)
- Authorization is enforced at least once

**Example:**
- Only authenticated users can submit or view data

---

### 4. Real Data (Minimal but Persistent)
- A simple data model (even a single table or collection is fine)
- Data is generated or seeded
- Data persists across app restarts and redeploys

> No in-memory-only or hardcoded demo data.

---

### 5. Deployed to Azure (Required)
- The solution runs in **Azure**, not just locally
- Accessible via a real endpoint
- Any Azure service is acceptable

**Examples:**
- Azure App Service  
- Azure Container Apps  
- Azure Functions  
- Azure Static Web Apps  

---

## Scope Guidance (Important)

### We are **not** expecting:
- Full CRUD implementations
- Pixel-perfect UX
- Production-grade security hardening
- Extensive automated tests

### We **are** expecting:
- Intentional scope
- Clean frontend-to-backend integration
- Real authentication and data
- A successful Azure deployment
- Honest engineering tradeoffs

---

## What We’ll Look For
- Does it actually run?
- Is authentication real?
- Is data real and persistent?
- Were stubbed or mocked pieces removed?
- Did AI meaningfully accelerate delivery?

---

## The Bar (One Sentence)
**If this can survive a redeploy and a live demo without hand-waving, you nailed it.**

