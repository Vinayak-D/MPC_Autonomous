clc; close all; clear; format bank;

%Model Predictive Control - User Inputs

%% System Model

model = struct;
model.Hinv = [0.020217913248018, 0.137507281293876; 0.137507281293876, 0.961857076668051];
model.U0 = [0;0];

%% Constraint Model

constraints = struct;
constraints.M = [1,0; -1,0; 0,1; 0,-1];
constraints.g = [0.4363; -0.4363; 1.00; -0.15];

%Incremental Constraints used >> 1, not used >> 0
g_init = 0;

%% Quadratic Program Parameters (pre-calculated)

QP = struct;
QP.W = 0.5*(constraints.M*model.Hinv*(constraints.M'));
QP.Wm = max(-QP.W,0);
QP.Wp = max(QP.W,0);
QP.l_0 = 0.1*ones(length(constraints.g),1);  
QP.e_0 = 1.0;
lam.Data = QP.l_0';
lam_old = lam.Data;

%% Temporary Variables

U_unc = [0.0254; -0.3325];
f = [-4.2096152960; -2.8665461266];