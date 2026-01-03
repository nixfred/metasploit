# NIGHTFALL - Story Bible

> **Classification: EYES ONLY**
> This document defines the narrative framework for P3N73S7 L4B

---

## THE PREMISE

Three weeks ago, you intercepted a fragment of encrypted traffic that wasn't meant for you. A scheduling conflict. A misconfigured relay. An accident.

What you found references something called **NIGHTFALL**.

Since then, you've been piecing it together. And someone has noticed. Your apartment was searched. Your accounts were probed. A car has been parked outside your building for six days.

You're running out of time. And the only way out is through.

---

## THE CONSPIRACY

### Operation NIGHTFALL

A coordinated attack on US critical infrastructure - power grid, water treatment, financial systems. The attack will be devastating. Thousands will die.

And it will be blamed on China.

The goal: manufacture a casus belli. Justify military action. Contracts worth trillions. A war that certain people have been waiting for.

The evidence will be perfect. Chinese malware signatures. IP addresses traced to Beijing. A "cyber Pearl Harbor" that demands retaliation.

But it's a lie. NIGHTFALL is domestic. And you're the only one who knows.

---

## THE ANTAGONIST

### Cerberus Systems

A defense contractor operating in the shadows between government and private sector. Officially, they provide "infrastructure security consulting." Unofficially, they are the operational arm of NIGHTFALL.

**Key Facts:**
- Founded 2003, post-9/11 security boom
- $2.3B in classified contracts
- Headquarters: Arlington, VA (public), unknown black sites
- CEO: Marcus Webb (former NSA, never photographed)
- Motto: "Vigilance Through Strength"

**Their Infrastructure (our targets):**
- Legacy FTP servers (vsftpd) - old but still holding data
- Sysadmin workstations (SSH) - the people who know
- Deployment systems (Tomcat) - where NIGHTFALL is being staged
- Executive file shares (Samba) - the paper trail
- Build farms (DistCC) - compiling the attack tools
- Public portals (DVWA) - the legitimate front
- Backend databases (SQLi) - the target lists
- Financial fronts (Juice Shop) - money laundering

---

## THE PROTAGONIST

**You.**

We don't define you. You're whoever is sitting at the keyboard.

What we know:
- Technical skills (you're doing this, aren't you?)
- You stumbled onto something you shouldn't have
- You're scared but you can't stop
- You don't know if you're a hero or a patsy

---

## THE HANDLER

### Unknown Contact

Someone is helping you. Encrypted messages arrive with intel, targets, guidance. They seem to know more than they should.

**Message Style:**
```
> INCOMING [ENCRYPTED]
> ========================
> The Tomcat server at 172.20.0.19 handles
> Cerberus deployment staging. Marcus Webb
> approved the current build three days ago.
>
> Whatever NIGHTFALL is, it's being assembled
> there.
>
> Get inside. Find out what they're building.
>
> And watch your back. They're getting closer.
> ========================
> [END TRANSMISSION]
```

**The Ambiguity:**
- Are they a fellow whistleblower?
- An insider with a conscience?
- A foreign agent using you?
- Someone setting you up to take the fall?

You never find out. That's the point.

---

## EPISODE STRUCTURE

Each episode follows this format:

### 1. HANDLER MESSAGE
Encrypted intel that sets up the target and raises the stakes.

### 2. EPISODE INTRO
Inner monologue. Paranoid. Urgent. Sets the emotional tone.

### 3. THE HACK
Step-by-step technical instructions with narrative explanations (2-4 sentences each). Each step advances both the skill and the story.

### 4. THE DISCOVERY
What you find inside. Documents. Schedules. Names. Each episode reveals another piece of NIGHTFALL.

### 5. EPISODE OUTRO
Cliffhanger. What comes next. The walls closing in.

---

## EPISODE GUIDE

### Episode 1: "THE FORGOTTEN DOOR"
**Target:** vsftpd (172.20.0.15)
**Story:** An old FTP server Cerberus forgot to decommission. Contains archived project files. You find the first reference to NIGHTFALL - a scheduling document with dates and codenames.
**Discovery:** A list of internal Cerberus IPs. And a name: David Chen, Senior Systems Administrator.

### Episode 2: "WEAK LINKS"
**Target:** vulnssh (172.20.0.17)
**Story:** David Chen's home workstation. He's been missing for two weeks. Police say he "left voluntarily." His password was weak - he was scared, distracted, sloppy. His browser history shows he was researching NIGHTFALL. He knew.
**Discovery:** Screenshots of internal memos. A Tomcat deployment URL. He was building a case.

### Episode 3: "THE DEPLOYMENT"
**Target:** tomcat (172.20.0.19)
**Story:** Cerberus's internal deployment system. Whatever they're building for NIGHTFALL, the components are staged here. You upload your own payload. You're inside their pipeline now.
**Discovery:** Build manifests. Something called "SCADA-BRIDGE." Deployment scheduled for 72 hours from now.

### Episode 4: "SHARED SECRETS"
**Target:** samba (172.20.0.16)
**Story:** Executive file shares. The paper trail. Marcus Webb's private files. If there's a smoking gun, it's here.
**Discovery:** Wire transfer receipts to shell companies. Photos from a private meeting. A map with targets marked.

### Episode 5: "THE BUILD FARM"
**Target:** metasploitable2/distcc (172.20.0.20)
**Story:** Their distributed compilation infrastructure. They're building something at scale. The code is obfuscated but the targets are clear: industrial control systems.
**Discovery:** Compiled binaries with Chinese language strings embedded. False flag breadcrumbs. This is how they'll blame Beijing.

### Episode 6: "INPUT VALIDATION"
**Target:** dvwa command injection (172.20.0.10)
**Story:** Cerberus's public-facing customer portal. Behind the corporate facade, the application is riddled with vulnerabilities. Just like their security theater.
**Discovery:** Customer list that doesn't match any real companies. Shell corporations. Money laundering fronts.

### Episode 7: "THE QUERY"
**Target:** dvwa SQLi (172.20.0.10)
**Story:** The database behind the portal. This is where they keep the real records. The ones they think no one will ever see.
**Discovery:** Target list for NIGHTFALL. Power substations. Water treatment plants. Financial clearing houses. Dates. Times. Coordinates.

### Episode 8: "STOREFRONT"
**Target:** juiceshop (172.20.0.30)
**Story:** The final piece. A legitimate-looking e-commerce front that launders NIGHTFALL funding. This is how you trace the money back to its source.
**Discovery:** The full picture. Everything you need to expose NIGHTFALL. But as you extract the final files, your connection drops. They've found you. Now it's a race.

---

## TONE GUIDE

**Voice:** Second person, present tense. Paranoid. Urgent. Technical but human.

**DO:**
- Short sentences when tension is high
- Technical accuracy (this is educational)
- Moral ambiguity
- Real stakes (people will die)
- Sensory details (the hum of the fan, the glow of the screen)

**DON'T:**
- Over-explain the tech (show, don't tell)
- Make the protagonist a hero (they're desperate)
- Resolve the ambiguity (is the handler trustworthy?)
- Happy endings (this is noir)

**Example Tone:**

> The cursor blinks. Waiting.
>
> Hydra found the password in eleven seconds. password123. David Chen was a
> senior sysadmin with twenty years of experience and a TS/SCI clearance.
>
> He knew better.
>
> But scared people make mistakes. And David Chen was very, very scared.
>
> His browser history confirms it. Three weeks of searches. "NIGHTFALL
> cerberus." "infrastructure attack false flag." "whistleblower protection
> laws."
>
> He was building a case. Gathering evidence. Trying to figure out who to
> trust.
>
> Then he disappeared.
>
> You're sitting in his digital footprints now. And somewhere, someone is
> sitting in yours.

---

## TERMINOLOGY

| Term | Definition |
|------|------------|
| NIGHTFALL | The operation. Infrastructure attack + false flag |
| Cerberus Systems | The contractor. The enemy. |
| SCADA-BRIDGE | The malware. Bridges IT and OT networks. |
| The Handler | Anonymous contact. Unclear motives. |
| David Chen | Missing sysadmin. Knew too much. |
| Marcus Webb | Cerberus CEO. The man at the top. |

---

## FUTURE EXPANSION

Ideas for later phases:
- Intercepted emails displayed between steps
- "Redacted" documents as props
- Handler messages that respond to progress
- Multiple endings based on user choices
- Audio logs (if we want to go full ARG)

---

*"Three can keep a secret, if two of them are dead."*
— Benjamin Franklin

---
