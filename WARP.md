# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

Braintoss Rebuild is a ground-up rebuild of the Braintoss application, focused on modern architecture and improved user experience. This is currently an early-stage project with the basic repository structure in place.

## Project Status

This is a greenfield project with:
- Basic repository structure (`src/`, `docs/`, `tests/`)
- Initial README.md outlining the project goals
- .gitignore configured for a Node.js/JavaScript project
- Empty source directories ready for development

## Technology Stack

Based on the .gitignore configuration, this project is intended to be a Node.js/JavaScript application with support for:
- Node.js/npm/yarn ecosystem
- Modern JavaScript frameworks (potential Next.js support indicated by `.next` in .gitignore)
- Standard JavaScript build tools and bundlers

## Repository Structure

```
braintoss-rebuild/
├── src/           # Main source code (currently empty)
├── tests/         # Test files (currently empty)
├── docs/          # Documentation (currently empty)
├── README.md      # Project overview and getting started
└── .gitignore     # Git ignore patterns for Node.js projects
```

## Development Setup

Since this is an early-stage project, the development setup will need to be established. Based on the project structure and .gitignore, the typical setup would likely involve:

```bash
# Initialize npm project (when package.json is created)
npm install

# Start development server (when configured)
npm run dev
# or
npm start

# Run tests (when test framework is configured)
npm test
# or
npm run test

# Build for production (when build process is configured)
npm run build

# Lint code (when linting is configured)
npm run lint
```

## Architecture Notes

The project structure suggests a standard modern JavaScript application architecture:

- **Source Organization**: The `src/` directory is prepared for the main application code
- **Testing Strategy**: Dedicated `tests/` directory indicates a focus on testing from the start
- **Documentation**: `docs/` directory shows commitment to maintaining documentation

## Development Guidelines

When contributing to this project:

1. **Project Structure**: Follow the established directory structure with `src/`, `tests/`, and `docs/`
2. **Technology Choices**: Given the .gitignore patterns, maintain consistency with Node.js/JavaScript ecosystem choices
3. **Documentation**: Keep the README.md updated as the project develops and add detailed documentation to the `docs/` directory
4. **Testing**: Implement comprehensive tests in the `tests/` directory as code is developed

## Future Considerations

As this project develops, consider updating this WARP.md file to include:

- Specific build commands and development workflows
- Architecture patterns and conventions adopted
- API documentation and service integration details
- Deployment procedures and environment configuration
- Code style and contribution guidelines

## Commands Reference

*This section will be populated as the project development progresses and specific tooling is implemented.*