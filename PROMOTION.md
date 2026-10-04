# Promotion plan

Position this project as: Portable CLI adaptation of 46 pstack agent skills. State the exact supported baseline, demonstrated behavior, and remaining qualification gates. Link the README, source provenance, and open testing tasks. Do not call a personal fork community-supported before other maintainers join.

Start with the receiving upstream maintainers for a narrowly scoped compatibility fix. For unofficial Asahi distribution experiments, use [Asahi's community channels](https://asahilinux.org/community/), especially `#asahi-alt`, and follow its [contribution rules](https://asahilinux.org/contribute/). Asahi's [AI policy](https://asahilinux.org/slop/) applies to material submitted to its project. An AI-assisted personal fork is not an exemption for an upstream submission.

For Omarchy and desktop work, use [Omarchy Discussions](https://github.com/omacom/omarchy/discussions) and relevant upstream project discussions. A tested screenshot or short clip, installation/removal link, version list, and one specific request for feedback make the post useful. After technical review, consider r/omarchy, r/AsahiLinux, r/hyprland, and a personal Mastodon or Bluesky post after checking each community's current rules. These secondary channels have not been vetted for permission to advertise.

Draft announcement:

> I published pstack-cli, an unofficial project for portable cli adaptation of 46 pstack agent skills. The README records the tested baseline and remaining gaps. I am looking for contributors to reproduce the first open roadmap task and report versions plus redacted results. Source, attribution, installation or test instructions, and rollback or scope limits are in https://github.com/Connorbelez/pstack-cli.

For the kernel package, describe the observed J293 USB-C-to-HDMI result and request reconnect/suspend/recovery qualification. For Touch ID, describe candidate fault tests and unresolved persistence; ask for source review, not users to replace authentication. For the workspace plugin, show independent active indicators on two monitors and ask for hotplug reports. For Dobby and Phantomat, lead with the ARM64 reproduction and focused upstream diff.

Publish no announcement automatically. Update the README and compatibility record before a release announcement, then link the release notes from the same discussion thread rather than repeating promotional posts.

For this CLI skill bundle, first discuss the portability delta with [pstack upstream](https://github.com/cursor/plugins). Share a minimal reproducible workflow, the manifest revision, and the exact Codex/OpenCode version. Next use relevant CLI-agent community discussions after checking their posting rules. Do not lead with desktop or kernel promotion channels for this project.
