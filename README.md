# Acceleration-Based User Authentication

Coursework project for **PUSL3123 – Artificial Intelligence & Machine Learning** (Referrals), University of Plymouth.

## Overview

MATLAB implementation of a behavioural-biometric authentication system that verifies a user's identity from accelerometer-derived feature vectors. A feedforward neural network is trained per user to distinguish that user's genuine samples from impostor samples drawn from the other users, and evaluated using standard biometric error metrics (FAR, FRR, EER).

## Project Structure

```
data/       Raw per-user accelerometer feature sets (10 users; time-domain,
            frequency-domain, and combined time+frequency-domain feature
            vectors, across two recording sessions per user)
scripts/    MATLAB pipeline (see below)
results/    Saved outputs from the experiments
report/     Draft coursework report
```

### Scripts

| Script | Purpose |
|---|---|
| `load_dataset.m` | Loads all users' feature data into a single struct |
| `make_genuine_impostor_set.m` | Builds a genuine/impostor sample set for a target user |
| `descriptive_stats.m` | Exploratory feature statistics and plots |
| `train_baseline_nn.m` | Trains a baseline neural network authentication model |
| `train_and_evaluate_user.m` | Trains/evaluates a per-user model (accuracy, FAR, FRR, scores) |
| `compute_eer.m` | Computes the Equal Error Rate from genuine/impostor scores |
| `run_all_users.m` | Runs the baseline pipeline across all 10 users with repeated trials |
| `run_feature_selection_sweep.m` | Sweeps feature-set size (top-K ranked features) to find the best K |
| `run_hyperparam_sweep.m` | Sweeps hidden-layer size to find the best network configuration |
| `confirm_hidden_size.m` | Confirmation runs comparing shortlisted hidden-layer sizes |

## Methodology

1. Load per-user accelerometer feature vectors (time-domain + frequency-domain).
2. Construct genuine/impostor sample sets per user.
3. Train a feedforward pattern-recognition neural network to classify genuine vs. impostor.
4. Evaluate with accuracy, False Acceptance Rate (FAR), False Rejection Rate (FRR), and Equal Error Rate (EER).
5. Sweep feature-set size and hidden-layer size to optimise the model, then confirm the best configuration with repeated trials.

## Requirements

- MATLAB with the Deep Learning Toolbox (for `patternnet` / `train`)

## Author

Punuja Lokith — sole contributor
