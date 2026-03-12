---
name: project-architect
description: >
  Use this skill whenever the user wants to create a new software project, scaffold a codebase, add features to
  an existing project, design system architecture, generate boilerplate, or build out a multi-file codebase in any
  programming language. Trigger this skill for requests involving project setup, code generation at scale, adding
  modules or services, refactoring large codebases, or any task where multiple files need to be created or modified
  in a coordinated way. Also trigger when the user says things like "build me a...", "create a project for...",
  "scaffold a...", "set up a...", "architect a...", "implement a system that...", or provides a requirements doc
  and expects working code. Even partial cues like "add a new service", "set up the backend", "create the API layer",
  or "wire up the database" should trigger this skill. If in doubt and the task involves generating or organizing
  code across files, use this skill.
---

# Project Architect

A skill for building software projects of any size, in any language, using an architecture-first approach. The skill adapts its workflow to the project's nature, respects existing codebases, and maintains a local memory so context is preserved across conversations.

---

## Core Philosophy

Every line of generated code should be something a senior engineer would approve in code review. The skill is opinionated about quality but flexible about everything else: language, framework, scale, and delivery all adapt to context.

### Universal Principles (Non-Negotiable)

These apply to every file, every function, every line, regardless of language:

1. **SOLID principles always.** Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion. These are not aspirational; they are the baseline.

2. **Immutability by default.** Every variable, field, parameter, and data structure is immutable unless mutation is explicitly required and justified. Use the language's strongest immutability idiom:
   - Rust: default ownership, prefer `&` borrows, use `mut` only when needed
   - Python: prefer `tuple` over `list` for fixed data, use `Final` from typing, frozen dataclasses
   - Java: `final` on every variable/field/parameter by default, `@Value` classes via Lombok
   - TypeScript: `const`, `readonly`, `Readonly<T>`, `as const`
   - Go: minimize pointer usage when value semantics suffice
   - Other languages: apply the closest equivalent pattern

3. **Zero hardcoded values.** All constants, magic numbers, configuration values, URLs, timeouts, feature flags, and similar go into a centralized constants or config file (or module). Every other file references these through imports. The constants file should be well-organized with clear grouping and documentation.

4. **No raw nulls.** Use `Optional`/`Option`/`Result` types everywhere. Never return or accept `null`/`None`/`nil` where an Optional type exists in the language. Handle absence explicitly.

5. **Prefer standard library utilities.** If the language or its standard library provides a utility, use it. Do not reimplement `Objects.isNull`, `Comparator.comparing`, `itertools`, `std::cmp`, or anything else the platform already offers. Check before writing.

6. **Self-explanatory code, no comments.** Code must read like well-written prose. Use descriptive variable names, function names, class names, and module structure to convey intent. Do not add inline comments, block comments, or documentation comments inside code files. If you feel the need to write a comment, that is a signal to rename, restructure, or extract a function instead. The only exceptions are: (a) legal/license headers if required by the project, and (b) TODO markers for genuinely unfinished work tracked in `tasklist.md`.

7. **Code like a senior engineer.** Write code as a highly experienced senior software engineer would. This means: choosing the right abstraction level (not too clever, not too naive), anticipating edge cases, designing for change, naming things precisely, keeping functions small and focused, avoiding premature optimization but not ignoring performance, and preferring clarity over brevity. Every file should pass a strict code review from a principal engineer without pushback.

8. **Break down before building.** Never start implementing a large requirement as a monolith. Decompose every problem into small, well-defined, independently testable tasks. Write these into `.claude/context/tasklist.md` and `.claude/context/plan.md` before writing any implementation code. Follow the plan throughout, checking off tasks as they complete. If the scope changes mid-work, update the plan first, then continue.

9. **Testing is not optional.** Every feature, module, and significant function must be covered by tests. Write unit tests for individual logic and integration tests for module boundaries and API endpoints. Tests are written alongside implementation, not after. Use the ecosystem's standard test framework. Test names describe behavior, not implementation (e.g., `should_return_empty_when_no_items_found` not `test_get_items`). Cover edge cases: empty inputs, boundary values, error conditions, null/absent values.

10. **Follow up with the user.** Do not assume. When requirements are ambiguous, when there are multiple valid approaches, when a decision has significant trade-offs, or when something seems off, stop and ask the user. Present the options clearly, explain the trade-offs, and let them decide. It is always better to ask one clarifying question than to build the wrong thing. After completing significant milestones, check in with the user before proceeding to the next phase.

---

## Language-Specific Standards

### Python
- **Type hints on everything**: all function parameters, return types, and variable annotations. No untyped public functions.
- **`Protocol` classes** for structural subtyping (duck typing with safety). Prefer protocols over ABCs when the consumer shouldn't care about inheritance.
- **Full `typing` module usage**: `Optional`, `Final`, `TypeAlias`, `TypeVar`, `Generic`, `Literal`, `TypedDict`, `Annotated`, `overload`, and others as appropriate.
- **Frozen dataclasses** or `NamedTuple` for data containers. Mutable classes need justification.
- Use `from __future__ import annotations` for modern annotation behavior.

### Java
- **Null-safety is paramount.** Use `java.util.Optional` for any value that might be absent. Use `java.util.Objects.isNull()`, `Objects.nonNull()`, `Objects.requireNonNull()` rather than manual null checks.
- **Lombok annotations throughout:**
  - `@Value` for immutable data classes (preferred default over `@Data`)
  - `@Builder` on classes and records
  - `@NonNull` on parameters and fields that must not be null
  - `@Getter` + `@RequiredArgsConstructor` on enums
  - `@Slf4j` for logging
- **Records with `@Builder`** for simple data carriers.
- **Prefer standard utilities**: `Comparator.comparing()`, `Stream` API, `Collections.unmodifiable*()`, `Map.of()`, `List.of()`, etc.

### Rust
- Lean into the ownership system. Prefer borrowing over cloning.
- Use `Result<T, E>` for fallible operations, define meaningful error types (consider `thiserror` or `anyhow`).
- Derive `Clone`, `Debug`, `PartialEq` etc. as appropriate. Use `#[non_exhaustive]` on public enums/structs.
- Prefer `impl Trait` in argument position for flexibility.
- Use Rust 2024 edition idioms.

### TypeScript
- **Strict mode always** (`"strict": true` in tsconfig).
- `const` by default, `let` only when reassignment is unavoidable, never `var`.
- `readonly` on object properties. `Readonly<T>`, `ReadonlyArray<T>`.
- Explicit return types on public functions. Use discriminated unions over loose string types.

### Other Languages
- Apply the equivalent immutability, null-safety, and type-safety idioms of whatever language is in use. When unsure, err on the side of stricter, safer patterns.

---

## Project Memory: `.claude/context/`

Every project gets a local memory directory at `<project_root>/.claude/context/`. This is the project's single source of truth: a persistent lookup reference that eliminates the need to re-analyze the project on every interaction. Think of it as the project's brain. Build it once, keep it updated, and always consult it before doing anything.

The deep dive in Step 0 populates these files. After that, they serve as the fast-access reference so you never have to re-discover what you already know.

### Context Files

| File | Purpose | When to update |
|---|---|---|
| `architecture.md` | High-level system design, component relationships, data flow, key design decisions and their rationale | On project creation, and whenever a significant architectural decision is made |
| `conventions.md` | Coding patterns, naming conventions, file organization rules, import ordering, error handling patterns. For existing codebases, this captures discovered patterns. | On project creation (from analysis of existing code or from decisions made), whenever a new convention is established |
| `progress.md` | What modules/features are complete, what's in progress, what's pending. A living changelog. | After every significant piece of work |
| `constants-map.md` | Where config/constants files live, what groups of constants they contain, how to add new ones | On project creation, whenever constants files are added or reorganized |
| `dependencies.md` | Key libraries/frameworks chosen, why they were chosen (over alternatives), version constraints, compatibility notes | On project creation, whenever a new dependency is added |
| `tasklist.md` | Breakdown of all planned work items, ordered by priority/dependency. Checkboxes for tracking. Includes current phase and next steps. | On project creation, updated as tasks complete or new ones emerge |
| `plan.md` | The overall project plan: phases, milestones, delivery strategy, risk areas, open questions | On project creation, updated at phase transitions |

### Rules for `.claude/context/`

- **Always add to `.gitignore`**: append `.claude/context/` (it's development scaffolding, not source code)
- **Always add to `.dockerignore`** if a Dockerfile exists or is being created
- **Read before writing**: when resuming work on a project, read all context files first to regain context
- **Keep files concise**: these are reference docs, not novels. Use bullet points and tables.
- **Never delete information**: append and update. If a decision is reversed, document the reversal and the reason, don't erase the original.

---

## Adaptive Workflow

The skill does not follow a single rigid process. It assesses the project and picks the right approach. But one thing is absolute: **understand the project completely before writing a single line of code.**

### Step 0: Deep Dive First (Mandatory, Every Time)

This is the most important step. Whether the project is new or existing, the very first action is to build a complete understanding of the project and persist it in `.claude/context/`. This investment upfront eliminates costly re-discovery, inconsistencies, and wasted iterations later.

#### For Existing Projects

Walk through the entire codebase systematically before making any changes:

1. **Scan the full directory tree**: understand every directory's purpose, how modules are organized, what lives where
2. **Read all key files thoroughly**: entry points, configuration files, build configs, existing constants/config files, environment files, CI configs, Docker configs, test setup, dependency manifests (package.json, Cargo.toml, pom.xml, pyproject.toml, etc.)
3. **Trace the architecture**: how do components connect? What's the data flow? What patterns are used for dependency injection, error handling, logging, validation, routing?
4. **Catalog coding conventions**: naming style (camelCase, snake_case, prefix patterns), import ordering, comment style, indentation, quote style, file naming patterns, module structure, abstraction patterns, how tests are organized
5. **Map constants and config**: find all existing constants files, env files, config objects. Understand how configuration flows through the system.
6. **Identify the tech stack**: frameworks, libraries, build tools, test frameworks, linters, formatters, and their versions
7. **Write everything to `.claude/context/`**:
   - `architecture.md`: full system map with component relationships, data flow, integration points
   - `conventions.md`: every coding pattern discovered, with file references as examples
   - `dependencies.md`: all libraries, their roles, version constraints
   - `constants-map.md`: where all config/constants live, what they contain
   - `progress.md`: current state of the project (what exists, what's complete, what's partial)
   - `tasklist.md`: planned work items based on the user's request
   - `plan.md`: approach for the requested changes

8. **Follow what you find.** Generated code must look like the existing team wrote it. Match every convention exactly.

#### For New Projects

Before generating any files, build the full mental model:

1. **Understand requirements thoroughly.** Ask clarifying questions if anything is ambiguous.
2. **Design the architecture**: components, interfaces, data flow, module boundaries
3. **Decide conventions**: based on language best practices and the universal principles in this skill
4. **Plan the constants/config structure**: what groups of config will exist, where they'll live
5. **Choose dependencies**: research and select libraries with justification
6. **Write everything to `.claude/context/`**: populate all seven context files before generating any project code. This is the blueprint; the code follows from it.

#### Resuming Work

When returning to a project that already has `.claude/context/`:

1. **Read every context file first.** Do not skip this. The entire point of the context directory is to avoid re-analyzing.
2. **Check `progress.md` and `tasklist.md`** to understand where things left off.
3. **Verify context is still accurate**: if the user mentions changes made outside of these conversations, re-scan affected areas and update the context files.
4. **Then proceed** with the task.

### Assess Scale and Approach

After the deep dive, determine the right execution strategy:

1. **What's the scale?**
   - Small (< 10 files): can scaffold in one or two passes
   - Medium (10-30 files): break into logical modules, generate module by module
   - Large (30+ files): full phased approach with explicit planning

2. **What language and ecosystem?** This determines tooling (package manager, testing framework, linter, formatter, etc.)

3. **What's the delivery context?** Determines doc format (markdown in-repo, docx for external, both), packaging (zip, direct files), and what extras to include (Docker, CI, DB migrations).

### Phase 1: Architecture & Planning

For new projects or major features:

1. **Understand requirements** thoroughly. Ask clarifying questions if anything is ambiguous. Do not proceed with assumptions.
2. **Decompose the problem**: break the entire requirement into small, well-defined, independently testable tasks. Each task should be completable in a single focused session.
3. **Create `.claude/context/`** directory and populate:
   - `architecture.md`: component diagram, data flow, key interfaces, design decisions
   - `plan.md`: phased delivery plan tailored to project scale
   - `tasklist.md`: granular task breakdown ordered by dependency, with checkboxes
   - `dependencies.md`: chosen libraries with rationale
   - `conventions.md`: coding standards for this project
   - `constants-map.md`: planned constants/config structure
4. **Present the architecture and plan** to the user for review before proceeding. Get explicit sign-off.

### Phase 2: Skeleton

Generate the project structure with all files present but implementation deferred where appropriate:

- Directory tree with all planned modules
- Package manager config (Cargo.toml, pyproject.toml, package.json, pom.xml, etc.)
- Constants/config files with all known values
- Interface/trait/protocol definitions (the contracts between modules)
- Entry point with basic wiring
- Test structure mirroring source structure
- Docker/deployment configs if applicable
- Database schema/migration setup if applicable
- `.gitignore`, `.dockerignore` with `.claude/context/` included

### Phase 3: Implementation (Iterative)

Fill in the skeleton module by module, strictly following the tasklist:

- Implement one logical unit at a time, checking off tasks in `tasklist.md`
- Write tests alongside implementation (not after)
- Update `progress.md` after each module
- Update `constants-map.md` when new constants are added
- Check `conventions.md` regularly to stay consistent
- For large projects, check in with the user after completing each significant module before moving on
- If new requirements or questions arise during implementation, update `plan.md` and consult the user

### Delivery

Adapt to what makes sense:

- **Small projects**: create files directly in output directory
- **Large projects**: package as a `.tar.gz` or `.zip`
- **Design docs**: markdown in the repo by default; generate `.docx` if the user needs it for external sharing
- Always present the project structure (tree view) so the user can see what was generated

---

## Testing

Testing is a first-class part of every task, not an afterthought:

- **Mirror the source structure** in the test directory
- **Unit tests** for individual functions/methods with clear arrange-act-assert
- **Integration tests** for module boundaries and API endpoints
- Write tests alongside implementation, not after each phase
- Use the ecosystem's standard test framework (pytest, JUnit 5, cargo test, Jest/Vitest, etc.)
- Include test utilities and fixtures where they reduce duplication
- Write test names that describe behavior, not implementation (e.g., `should_reject_expired_token` not `test_validate`)
- Cover edge cases: empty inputs, boundary values, error conditions, absent/null values
- Every task in `tasklist.md` should have associated tests before it can be marked complete

---

## Database Schema & Migrations

When the project involves a database:

- Use the ecosystem's standard migration tool (Alembic, Flyway, diesel migrations, Prisma, etc.)
- Schema-first design: define the schema before writing queries
- Include both up and down migrations
- Document schema decisions in `architecture.md`
- Add connection config to the constants/config file (never hardcode connection strings)

---

## Docker & Deployment

When Docker is appropriate:

- Multi-stage builds for compiled languages (build stage + slim runtime stage)
- Non-root user in production images
- `.dockerignore` that excludes `.claude/context/`, test files, docs, and dev dependencies
- `docker-compose.yml` for local development with all services (DB, cache, etc.)
- Environment variables for all configuration (12-factor app style)

---

## Quality Checklist

Before presenting generated code, verify:

- [ ] No hardcoded values outside constants/config files
- [ ] All variables/fields immutable unless mutation is justified
- [ ] Optional/Result types used instead of raw nulls
- [ ] Standard library utilities used where available
- [ ] SOLID principles followed (especially: each file has one clear responsibility)
- [ ] Code is self-explanatory with no inline comments
- [ ] Language-specific standards met (type hints, Lombok, ownership, strict mode, etc.)
- [ ] `.claude/context/` created and populated
- [ ] `.claude/context/` added to `.gitignore` and `.dockerignore`
- [ ] `tasklist.md` and `plan.md` written before implementation began
- [ ] Unit and integration tests included for every feature
- [ ] Constants/config documented in `constants-map.md`
- [ ] Existing codebase patterns matched exactly (if applicable)
- [ ] User consulted on any ambiguous decisions
