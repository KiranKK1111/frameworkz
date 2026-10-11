import 'package:drift/drift.dart';

import '../db/database.dart';

/// Built-in email templates seeded on first launch. Users can edit or delete
/// them; "Restore defaults" in Settings re-seeds anything missing.
List<EmailTemplatesCompanion> defaultEmailTemplates() {
  final now = DateTime.now();
  int order = 0;

  EmailTemplatesCompanion t({
    required String id,
    required String name,
    LeadStatus? trigger,
    String category = 'lead',
    required String subject,
    required String body,
  }) =>
      EmailTemplatesCompanion.insert(
        id: id,
        name: name,
        triggerStatus: Value(trigger),
        category: Value(category),
        subject: subject,
        body: body,
        isBuiltIn: const Value(true),
        sortOrder: Value(order++),
        updatedAt: now,
      );

  return [
    t(
      id: 'tpl_contacted',
      name: 'First touch · Introduction',
      trigger: LeadStatus.contacted,
      subject: 'Quick hello from {{my_business}} 👋 {{business}}',
      body: '''Hi {{first_name}},

Thanks for reaching out about {{service}} for {{business}} — loved what I saw so far.

I'm {{my_name}} from {{my_business}}. We help brands like yours turn ideas into content that actually gets watched: crisp edits, scroll-stopping reels and films with real cinematic polish.

Would you be open to a quick 15-minute call this week? I'll walk you through a few relevant pieces of our work and understand exactly what you're looking for, so I can send you a proposal that fits.

Just reply with a time that works and I'll send over a calendar invite.

Looking forward to it!

{{signature}}''',
    ),
    t(
      id: 'tpl_replied',
      name: 'Reply received · Keep momentum',
      trigger: LeadStatus.replied,
      subject: 'Great to hear from you, {{first_name}} — next step for {{business}}',
      body: '''Hi {{first_name}},

Great to hear from you! Thanks for the details on what you have in mind for {{business}}.

Based on what you shared, {{service}} is a perfect fit, and I already have a couple of ideas on direction and format.

Let's hop on a short call so I can hear your goals first-hand. Do any of these work for you?

• Tomorrow, 11:00 AM
• Tomorrow, 4:00 PM
• Day after, 11:00 AM

Reply with one and I'll lock it in with a Google Meet link.

{{signature}}''',
    ),
    t(
      id: 'tpl_call_scheduled',
      name: 'Meeting confirmation',
      trigger: LeadStatus.callScheduled,
      subject: 'Confirmed: our call on {{meeting_date}} at {{meeting_time}} · {{my_business}} × {{business}}',
      body: '''Hi {{first_name}},

Confirming our call:

📅 {{meeting_date}}
⏰ {{meeting_time}}
🔗 {{meet_link}}

On the call I'll walk you through how we'd approach {{service}} for {{business}}, share some relevant work, and answer any questions. If you have brand guidelines or references you love, feel free to send them over beforehand.

Talk soon!

{{signature}}''',
    ),
    t(
      id: 'tpl_proposal_sent',
      name: 'Proposal sent',
      trigger: LeadStatus.proposalSent,
      subject: 'Proposal for {{business}} · {{service}} by {{my_business}}',
      body: '''Hi {{first_name}},

As promised, here's the proposal for {{service}} for {{business}}:

{{proposal_link}}

Inside you'll find the creative approach, deliverables, timeline and investment. I've kept it focused on what will move the needle for you.

Happy to jump on a quick call to walk through it, or feel free to reply with any questions. If everything looks good, just say "let's go" and I'll send across the onboarding details.

Excited about this one!

{{signature}}''',
    ),
    t(
      id: 'tpl_negotiation',
      name: 'Proposal follow-up',
      trigger: LeadStatus.negotiation,
      subject: 'Following up on the {{service}} proposal for {{business}}',
      body: '''Hi {{first_name}},

Just checking in on the proposal I sent for {{business}}.

I know budgets and timelines need to line up, so if there's anything you'd like to adjust — scope, deliverables, phasing or payment terms — I'm glad to work with you on it.

Would it help to hop on a quick 10-minute call to iron out the details?

{{signature}}''',
    ),
    t(
      id: 'tpl_nurture',
      name: 'Nurture · Stay in touch',
      trigger: LeadStatus.nurture,
      subject: 'Staying in touch — {{my_business}} × {{business}}',
      body: '''Hi {{first_name}},

Hope things are going well at {{business}}!

I wanted to stay in touch — we've been working on some exciting {{service}} projects lately and I'd love to share a couple with you when the timing is right.

If content is back on the agenda, I'm just one reply away. No pressure at all.

Have a great week!

{{signature}}''',
    ),
    t(
      id: 'tpl_won',
      name: 'Won · Welcome aboard',
      trigger: LeadStatus.won,
      subject: 'Welcome aboard, {{business}}! 🎉 Next steps',
      body: '''Hi {{first_name}},

Thrilled to be working together on {{service}} for {{business}}!

Here's what happens next:

1. Onboarding call — we'll align on goals, brand voice and references.
2. Shared Drive folder — I'll create one for scripts, raw footage and deliverables.
3. Production plan — shoot dates, edit timeline and delivery milestones.

I'll send a calendar invite for the onboarding call shortly. Welcome to the {{my_business}} family!

{{signature}}''',
    ),
    t(
      id: 'tpl_lost',
      name: 'Lost · Keep the door open',
      trigger: LeadStatus.lost,
      subject: 'Thank you, {{first_name}} — the door stays open',
      body: '''Hi {{first_name}},

Thanks for considering {{my_business}} for {{business}}. I completely understand the decision, and I appreciate the time you spent with me.

If priorities change or a new project comes up, I'd love to pick the conversation back up — just reply to this email anytime.

Wishing you and the team all the best!

{{signature}}''',
    ),
    t(
      id: 'tpl_generic_followup',
      name: 'Generic follow-up',
      subject: 'Checking in — {{business}} × {{my_business}}',
      body: '''Hi {{first_name}},

Just circling back on our conversation about {{service}} for {{business}}.

Is there anything I can help clarify, or any information you need from my side to move forward?

{{signature}}''',
    ),
    t(
      id: 'tpl_invoice_sent',
      name: 'Invoice sent',
      category: 'invoice',
      subject: 'Invoice {{invoice_id}} from {{my_business}} · {{invoice_amount}}',
      body: '''Hi {{first_name}},

Please find the details for invoice {{invoice_id}}:

Amount: {{invoice_amount}}
Due date: {{invoice_due}}

Let me know once the payment is made, or if you need any changes to the invoice. Thank you for your business!

{{signature}}''',
    ),
    t(
      id: 'tpl_payment_reminder',
      name: 'Payment reminder',
      category: 'invoice',
      subject: 'Gentle reminder: invoice {{invoice_id}} due {{invoice_due}}',
      body: '''Hi {{first_name}},

A gentle reminder that invoice {{invoice_id}} for {{business}} has an outstanding balance of {{invoice_balance}}, due on {{invoice_due}}.

If the payment is already on its way, please ignore this note. Otherwise, I'd appreciate it if you could process it at your earliest convenience.

Thanks so much!

{{signature}}''',
    ),
    t(
      id: 'tpl_project_review',
      name: 'Project ready for review',
      category: 'project',
      subject: '{{project_name}} is ready for your review 🎬',
      body: '''Hi {{first_name}},

Exciting news — {{project_name}} is ready for your review!

You'll find the files in your shared Drive folder. Please go through it and share your feedback or approval. One round of revisions is included, so don't hold back on notes.

Can't wait to hear what you think!

{{signature}}''',
    ),
  ];
}
