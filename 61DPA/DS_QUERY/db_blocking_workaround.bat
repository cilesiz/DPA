"C:\Program Files\EMC\dpa\services\bin\dpa.bat" ds query "DROP VIEW dpa.alerts_v;

CREATE OR REPLACE VIEW dpa.alerts_v AS
    SELECT a.f_id, a.f_lastmodified, a.category, a.count, a.description, a.issued, a.last_occurrence, a.nodeid,
       a.childnodeid, a.message, a.component, a.componentid, a.additionalid, a.componentnodeid, a.policyid, a.raalertinternalid, a.raalert, a.resolution, a.ruleid,
       a.severity, a.state, a.policytype, a.associatedfunctionname, a.associatedModuleName, a.rctemplatesymptomid,a.rcTemplateSymptomName, analysis_policy.name as analysispolicyname,
       policies.f_name as datacollectionpolicyname,  chargeback_policy.f_name as chargebackpolicyname, protection_policy.name as protectionpolicyname,
       r.name as rulename, an.f_name as object, cn.f_name as childobject, cpn.f_name as componentobjectname,
       an.dtype AS objectType, cn.dtype AS childObjectType, cpn.dtype AS componentType
       FROM dpa.analysisalert a
       LEFT JOIN dpa.analysispolicy analysis_policy ON analysis_policy.f_id = a.policyid
       LEFT JOIN dpa.policies policies ON policies.f_id = a.policyid
       LEFT JOIN dpa.ChargebackPolicy chargeback_policy ON chargeback_policy.f_id = a.policyid
       LEFT JOIN dpa.ProtectionPolicy protection_policy ON protection_policy.f_id = a.policyid
       LEFT JOIN dpa.analysisruletemplate r ON r.f_id = a.ruleid
       LEFT JOIN apollo.node an ON an.f_id = a.nodeid
       LEFT JOIN apollo.node cn ON cn.f_id = a.childnodeid
       LEFT JOIN apollo.node cpn ON cpn.f_id = a.componentnodeid;

ALTER TABLE dpa.alerts_v OWNER TO apollouser;"
