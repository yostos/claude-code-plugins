# MAGI System Help

Display comprehensive help information about the MAGI (Multi-Agent Governance Intelligence) system.

## Instructions

Read the complete specifications from `Claude.md` and present the following information to the user in Japanese:

1. **System Overview**
   - What MAGI is and how it works
   - The purpose of multi-perspective deliberation

2. **Agent Configuration**
   - ARBITRATOR: Problem structuring and final arbitration
   - MELCHIOR: Scientific/technical analysis
   - BALTHASAR: Legal/ethical analysis
   - CASPER: Emotional/trend analysis

   For each agent, briefly explain their role and characteristics.

3. **Usage**
   - How to invoke the MAGI system
   - Command formats:
     - `/magi` - Interactive mode
     - `/magi [issue description]` - Direct issue description
     - `/magi-help` - Display this help

4. **Execution Flow**
   - Phase 1: Problem structuring by ARBITRATOR
   - Phase 2: Parallel analysis by three agents
   - Phase 2.5: Vote analysis - if 2-1 split, ask user whether to enter deliberation
   - Phase 3: Deliberation (conditional) - 4-round structured debate between majority and minority agents, followed by revote. Only triggers on 2-1 split with user approval.
   - Phase 4: Final arbitration with vote tallying and conclusion

5. **About Deliberation Phase**
   - Explain that deliberation only triggers when votes split 2-1 AND the user approves
   - Describe the 4-round debate protocol:
     - Round 1: Majority presents arguments to minority
     - Round 2: Minority sends counterarguments
     - Round 3: Majority responds
     - Round 4: Minority sends final rebuttal (guaranteed last word)
   - After debate, all agents revote - they may change their position if persuaded
   - If user declines deliberation, the system proceeds with initial votes

6. **Important Notes**
   - Agent independence
   - Judgment fairness
   - Information gathering capabilities
   - Flexibility in decision-making

7. **Example Output**
   - Show a brief example of what the structured problem looks like
   - Show what the final conclusion format looks like

## Formatting

Use clear, well-structured Japanese with appropriate headers and bullet points. Make it easy to understand for users who are new to the MAGI system.

Include a note at the end that users can start using MAGI by typing `/magi` or `/magi [their issue]`.
