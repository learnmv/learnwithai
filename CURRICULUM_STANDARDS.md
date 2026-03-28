# LearnWithAI Curriculum Standards Integration

## Overview
LearnWithAI strictly follows the **California Common Core State Standards (CA CCSS)**. This document maps the standards to our database schema and content structure.

---

## California Common Core Structure

### Hierarchy
```
Grade Level (K-12, or Conceptual Categories for 9-12)
    └── Domain (e.g., Ratios and Proportional Relationships)
            └── Cluster (Group of related standards)
                    └── Standard (Specific learning objective)
                            └── Learning Objective (Breakdown for lessons)
```

### Standard Notation
- **K-8**: `{grade}.{domain}.{number}` → Example: `6.RP.1` (6th Grade, Ratios & Proportional Relationships, Standard 1)
- **9-12**: `{category}.{domain}.{number}` → Example: `N.RN.1` (Number and Quantity, The Real Number System, Standard 1)

---

## Database Schema Alignment

### Updated Schema for Standards

```sql
-- Standards Jurisdiction (California, Other States, etc.)
CREATE TABLE jurisdictions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(10) UNIQUE NOT NULL,  -- 'CA', 'TX', etc.
    type VARCHAR(50),                   -- 'state', 'national', 'district'
    is_active BOOLEAN DEFAULT TRUE
);

-- Standards Framework (CCSS, NGSS, etc.)
CREATE TABLE frameworks (
    id SERIAL PRIMARY KEY,
    jurisdiction_id INTEGER REFERENCES jurisdictions(id),
    name VARCHAR(100) NOT NULL,         -- 'Common Core State Standards'
    subject VARCHAR(50) NOT NULL,       -- 'mathematics', 'ela', 'science'
    version VARCHAR(20),                -- '2013', '2023'
    effective_date DATE,
    is_active BOOLEAN DEFAULT TRUE
);

-- Domains (e.g., Ratios and Proportional Relationships)
CREATE TABLE domains (
    id SERIAL PRIMARY KEY,
    framework_id INTEGER REFERENCES frameworks(id),
    name VARCHAR(200) NOT NULL,
    code VARCHAR(20) NOT NULL,          -- 'RP', 'NS', 'EE', etc.
    description TEXT,
    grade_level INTEGER,                -- NULL for high school conceptual categories
    order_index INTEGER DEFAULT 0
);

-- Clusters (Groups of related standards)
CREATE TABLE clusters (
    id SERIAL PRIMARY KEY,
    domain_id INTEGER REFERENCES domains(id),
    name VARCHAR(300) NOT NULL,
    description TEXT,
    order_index INTEGER DEFAULT 0
);

-- Individual Standards
CREATE TABLE standards (
    id SERIAL PRIMARY KEY,
    cluster_id INTEGER REFERENCES clusters(id),
    standard_code VARCHAR(50) UNIQUE NOT NULL,  -- '6.RP.1', '7.EE.3'
    description TEXT NOT NULL,
    learning_objective TEXT,             -- Student-facing learning goal
    conceptual_category VARCHAR(100),   -- For high school: 'Algebra', 'Functions', etc.
    is_major_work BOOLEAN DEFAULT FALSE, -- Focus standards for the grade
    is_california_addition BOOLEAN DEFAULT FALSE, -- CA-specific additions
    parent_standard_id INTEGER REFERENCES standards(id), -- For sub-standards
    metadata JSONB                      -- Flexibility for future attributes
);

-- Link Topics to Standards (Many-to-Many)
CREATE TABLE topic_standards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    topic_id INTEGER REFERENCES topics(id) ON DELETE CASCADE,
    standard_id INTEGER REFERENCES standards(id) ON DELETE CASCADE,
    coverage_level VARCHAR(20),          -- 'introduce', 'develop', 'master'
    priority INTEGER DEFAULT 1,          -- 1=primary, 2=secondary
    UNIQUE(topic_id, standard_id)
);

-- Student Mastery of Standards
CREATE TABLE standard_mastery (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    standard_id INTEGER REFERENCES standards(id) ON DELETE CASCADE,
    mastery_level VARCHAR(20),          -- 'not_started', 'emerging', 'developing', 'proficient', 'mastered'
    first_attempt_at TIMESTAMP WITH TIME ZONE,
    mastered_at TIMESTAMP WITH TIME ZONE,
    attempts_count INTEGER DEFAULT 0,
    correct_count INTEGER DEFAULT 0,
    last_assessed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, standard_id)
);

-- Quiz Questions linked to Standards
ALTER TABLE quiz_questions ADD COLUMN
    standard_id INTEGER REFERENCES standards(id) ON DELETE SET NULL;

-- Indexes
CREATE INDEX idx_standards_code ON standards(standard_code);
CREATE INDEX idx_standards_domain ON standards(cluster_id);
CREATE INDEX idx_topic_standards_topic ON topic_standards(topic_id);
CREATE INDEX idx_topic_standards_standard ON topic_standards(standard_id);
CREATE INDEX idx_standard_mastery_user ON standard_mastery(user_id);
CREATE INDEX idx_standard_mastery_level ON standard_mastery(mastery_level);
```

---

## 6th Grade Mathematics - CA CCSS Mapping

### Domain: Ratios and Proportional Relationships (6.RP)

| Code | Standard | LearnWithAI Topics |
|------|----------|-------------------|
| **6.RP.1** | Understand ratio concepts and use ratio language | Introduction to Ratios, Ratio Language |
| **6.RP.2** | Understand unit rate | Unit Rates, Comparing Ratios |
| **6.RP.3a** | Make tables of equivalent ratios | Ratio Tables, Scaling |
| **6.RP.3b** | Solve unit rate problems | Unit Price, Speed, Density |
| **6.RP.3c** | Find percent of a quantity | Percent Basics, Percent of a Number |
| **6.RP.3d** | Convert measurement units | Converting Units |

**Major Work:** Yes | **Critical Area:** 1

### Domain: The Number System (6.NS)

| Code | Standard | LearnWithAI Topics |
|------|----------|-------------------|
| **6.NS.1** | Divide fractions by fractions | Fraction Division, Visual Models |
| **6.NS.2** | Fluently divide multi-digit numbers | Long Division, Division Fluency |
| **6.NS.3** | Fluently operate with decimals | Decimal Operations, Decimal Fluency |
| **6.NS.4** | GCF and LCM | Factors and Multiples |
| **6.NS.5** | Understand positive/negative numbers | Intro to Integers, Opposite Quantities |
| **6.NS.6a** | Understand rational numbers on number line | Number Line, Rational Numbers |
| **6.NS.6b** | Position pairs of integers on coordinate plane | Coordinate Plane, Four Quadrants |
| **6.NS.6c** | Position rational numbers on number line and plane | Plotting Rational Numbers |
| **6.NS.7a** | Interpret statements of inequality | Comparing Rational Numbers |
| **6.NS.7b** | Write, interpret, explain order statements | Ordering Numbers |
| **6.NS.7c** | Understand absolute value | Absolute Value, Distance from Zero |
| **6.NS.7d** | Distinguish comparisons of absolute value | Absolute Value in Context |
| **6.NS.8** | Solve problems by graphing points | Coordinate Geometry Problems |

**Major Work:** Yes | **Critical Area:** 2

### Domain: Expressions and Equations (6.EE)

| Code | Standard | LearnWithAI Topics |
|------|----------|-------------------|
| **6.EE.1** | Write/evaluate expressions with exponents | Exponents, Powers of 10 |
| **6.EE.2a** | Write expressions with variables | Writing Expressions |
| **6.EE.2b** | Identify parts of an expression | Terms, Coefficients, Factors |
| **6.EE.2c** | Evaluate expressions at specific values | Evaluating Expressions |
| **6.EE.3** | Apply properties to generate equivalent expressions | Equivalent Expressions |
| **6.EE.4** | Identify equivalent expressions | Simplifying Expressions |
| **6.EE.5** | Understand solving equations | Equation Basics |
| **6.EE.6** | Use variables to represent numbers | Variables in Problem Solving |
| **6.EE.7** | Solve equations of form x + p = q, px = q | Solving One-Step Equations |
| **6.EE.8** | Write inequalities | Introduction to Inequalities |
| **6.EE.9** | Analyze relationships between variables | Independent/Dependent Variables, Graphing |

**Major Work:** Yes | **Critical Area:** 3

### Domain: Geometry (6.G)

| Code | Standard | LearnWithAI Topics |
|------|----------|-------------------|
| **6.G.1** | Find areas of triangles, quadrilaterals | Area of Polygons |
| **6.G.2** | Find volumes of prisms with fractional edges | Volume with Fractions |
| **6.G.3** | Draw polygons in coordinate plane | Coordinate Geometry |
| **6.G.4** | Represent 3D figures using nets | Nets and Surface Area |

**Major Work:** No | **Supporting Cluster**

### Domain: Statistics and Probability (6.SP)

| Code | Standard | LearnWithAI Topics |
|------|----------|-------------------|
| **6.SP.1** | Recognize statistical questions | Statistical Questions |
| **6.SP.2** | Understand data distribution | Data Distribution Concepts |
| **6.SP.3** | Recognize center, spread, shape | Measures of Center |
| **6.SP.4** | Display data in plots | Dot Plots, Histograms, Box Plots |
| **6.SP.5a** | Report number of observations | Summarizing Data |
| **6.SP.5b** | Describe attribute being measured | Data Attributes |
| **6.SP.5c** | Give quantitative measures of center | Mean, Median, Mode |
| **6.SP.5d** | Relate measures to data shape | Understanding Variability |

**Major Work:** No | **Supporting Cluster**

---

## Grade 7 Preview (Future Expansion)

### Major Work Domains

| Domain | Code | Focus Areas |
|--------|------|-------------|
| Ratios and Proportional Relationships | 7.RP | Scale drawings, multi-step ratio problems |
| The Number System | 7.NS | Operations with rational numbers |
| Expressions and Equations | 7.EE | Linear expressions, two-step equations |

---

## Standards for Mathematical Practice (K-12)

All content is designed to develop these 8 practices:

1. **MP.1** - Make sense of problems and persevere in solving them
2. **MP.2** - Reason abstractly and quantitatively
3. **MP.3** - Construct viable arguments and critique reasoning
4. **MP.4** - Model with mathematics
5. **MP.5** - Use appropriate tools strategically
6. **MP.6** - Attend to precision
7. **MP.7** - Look for and make use of structure
8. **MP.8** - Look for and express regularity in repeated reasoning

---

## Implementation Strategy

### Seed Data Structure

```json
{
  "jurisdictions": [
    {
      "id": 1,
      "name": "California",
      "code": "CA",
      "type": "state"
    }
  ],
  "frameworks": [
    {
      "id": 1,
      "jurisdiction_id": 1,
      "name": "California Common Core State Standards",
      "subject": "mathematics",
      "version": "2013",
      "effective_date": "2013-08-02"
    }
  ],
  "domains": [
    {
      "id": 1,
      "framework_id": 1,
      "name": "Ratios and Proportional Relationships",
      "code": "RP",
      "grade_level": 6,
      "order_index": 1
    },
    {
      "id": 2,
      "framework_id": 1,
      "name": "The Number System",
      "code": "NS",
      "grade_level": 6,
      "order_index": 2
    },
    {
      "id": 3,
      "framework_id": 1,
      "name": "Expressions and Equations",
      "code": "EE",
      "grade_level": 6,
      "order_index": 3
    },
    {
      "id": 4,
      "framework_id": 1,
      "name": "Geometry",
      "code": "G",
      "grade_level": 6,
      "order_index": 4
    },
    {
      "id": 5,
      "framework_id": 1,
      "name": "Statistics and Probability",
      "code": "SP",
      "grade_level": 6,
      "order_index": 5
    }
  ],
  "standards": [
    {
      "id": 1,
      "cluster_id": 1,
      "standard_code": "6.RP.1",
      "description": "Understand the concept of a ratio...",
      "learning_objective": "I can use ratio language to describe relationships between quantities",
      "is_major_work": true
    }
    // ... more standards
  ]
}
```

### API Endpoints for Standards

```python
# app/api/v1/standards.py

from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession

router = APIRouter(prefix="/standards", tags=["standards"])

@router.get("/grade/{grade_level}")
async def get_standards_by_grade(
    grade_level: int,
    subject: str = "mathematics",
    db: AsyncSession = Depends(get_db)
):
    """Get all standards for a specific grade level"""
    # Returns organized by domain → cluster → standard

@router.get("/{standard_code}")
async def get_standard_detail(
    standard_code: str,  # e.g., "6.RP.1"
    db: AsyncSession = Depends(get_db)
):
    """Get detailed information about a specific standard"""

@router.get("/{standard_code}/topics")
async def get_topics_for_standard(
    standard_code: str,
    db: AsyncSession = Depends(get_db)
):
    """Get all topics covering this standard"""

@router.get("/user/{user_id}/progress")
async def get_user_standards_progress(
    user_id: str,
    db: AsyncSession = Depends(get_db)
):
    """Get user's progress on all standards"""
```

---

## Quiz Generation Aligned to Standards

### AI Prompt Template

```python
STANDARD_ALIGNED_QUIZ_PROMPT = """Generate a quiz question aligned to California Common Core Standard {standard_code}.

STANDARD: {standard_description}

LEARNING OBJECTIVE: {learning_objective}

Requirements:
- Difficulty Level: {difficulty}/3
- Question Type: Multiple choice
- Distractors should be plausible based on common misconceptions
- Include real-world context where appropriate
- Follow CA CCSS mathematical practices

Return JSON:
{{
    "question": "...",
    "options": ["A", "B", "C", "D"],
    "correct_index": 0,
    "explanation": "...",
    "mp_alignment": ["MP.1", "MP.4"],  // Mathematical practices
    "common_misconceptions": ["..."]
}}
"""
```

---

## Progress Tracking by Standards

### Dashboard Metrics

```typescript
interface StandardsProgress {
  gradeLevel: number;
  totalStandards: number;
  masteredStandards: number;
  inProgressStandards: number;
  notStartedStandards: number;
  masteryPercentage: number;

  byDomain: {
    domainName: string;
    domainCode: string;
    total: number;
    mastered: number;
    percentage: number;
  }[];

  focusAreas: string[]; // Standards needing attention
  strengths: string[];  // Standards fully mastered
}
```

---

## External Standards API

### Common Standards Project

For importing official standards:

```bash
# API Endpoint
GET https://api.commonstandardsproject.com/api/v1/standards

# California CCSS Math
GET https://api.commonstandardsproject.com/api/v1/jurisdictions/CA/standards?subject=math
```

### Python Import Script

```python
# scripts/import_standards.py
import requests
from app.database import async_session
from app.models.standards import Standard, Domain, Framework

async def import_california_standards():
    """Import CA CCSS from Common Standards API"""
    url = "https://api.commonstandardsproject.com/api/v1/jurisdictions/CA/standards"

    response = requests.get(url)
    data = response.json()

    async with async_session() as db:
        # Process and insert standards
        for standard_data in data:
            await create_or_update_standard(db, standard_data)
```

---

## Resources

- [California Department of Education - CCSS](http://www.cde.ca.gov/ci/cc/)
- [CA Content Standards Search](https://www2.cde.ca.gov/cacs/math)
- [Common Standards Project API](https://github.com/commonstandardsproject/api)
- [CA Math Framework Grade 6](https://www.cde.ca.gov/ci/ma/cf/documents/mathfwgrade6lmg2.pdf)
- [Common Core State Standards Initiative](https://www.thecorestandards.org/Math/Content/6/)

---

## Summary

This standards-aligned approach ensures:
1. **Compliance** with California educational requirements
2. **Clear learning objectives** for every topic
3. **Measurable progress** on specific standards
4. **Adaptive quiz generation** based on standard mastery
5. **Parent/educator reporting** aligned to official standards
6. **Future scalability** to other states/frameworks (NGSS for Science, etc.)
