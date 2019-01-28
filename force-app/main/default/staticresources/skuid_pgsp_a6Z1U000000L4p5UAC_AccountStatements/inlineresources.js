(function(skuid){
skuid.snippet.register('generateStatementForm',function(args) {var params = arguments[0],
	$ = skuid.$;
	
var statementHeader = skuid.model.getModel('NewStatementHeader').data[0];
sforce.apex.execute('clcommon.CustomButtonAction', 'generateStatementsForm', {
                                statementId: statementHeader.Id,
                            }
                        );
});
skuid.snippet.register('refreshTabs',function(args) {var $ = skuid.$;
var tabs = skuid.component.getById('fs-aggregate');
    tabs.render();
});
skuid.snippet.register('BasePeriods',function(args) {var params = arguments[0],
	$ = skuid.$;
	
var statements = skuid.model.getModel('FinancialStatements').data;
console.log(statements);
var basePeriods = [];
var i;
for(i=0; i <statements.length ; i++){
    basePeriods.push({ label: statements[i].Name, value: statements[i].Id });
}
basePeriods.push({ label: 'Previous Period', value: 'Previous Period' });
console.log(basePeriods);
var statementModel = skuid.model.getModel('StatementDetailforSensitivity');
    console.log('here1');
    console.log(statementModel.data);
return basePeriods;
});
skuid.snippet.register('trendAnalysisRequest',function(args) {var params = arguments[0],
	$ = skuid.$;
	
var trendAnalysisReq = skuid.model.getModel('TrendAnalysisRequest').data[0];
var acc = skuid.model.getModel('ACStatementForAccount').data[0];
sforce.apex.execute('clcommon.CustomButtonAction', 'performTrendAnalysis', {
                                accId: acc.Id,
                                statementType: trendAnalysisReq.statementType,
                                basePeriod: trendAnalysisReq.basePeriod,
                                deletePreviousAnalysis:true
                            }
                        );
});
skuid.snippet.register('GenerateProjectedStatement',function(args) {var params = arguments[0],
	$ = skuid.$;
	
var statementHeader = skuid.model.getModel('ProjectionStatement').data[0];
console.log(statementHeader);
var statementParams = skuid.model.getModel('StatementParameters').data;
console.log(statementParams);
var acc = skuid.model.getModel('ACStatementForAccount').data[0];

var parameters = "{";
var i;
for(i = 0; i< statementParams.length ; i++){
    console.log(statementParams[i]);
    parameters += ("\"" + statementParams[i].TemplateDetail +"\"" + ":" + "\"" + statementParams[i].PercentChange+"\""+",");
}
parameters = parameters.slice(0,-1);
parameters+="}";
console.log(parameters);

sforce.apex.execute('clcommon.CustomButtonAction', 'generateProjectedStatement', {
                                statementName : statementHeader.Name,
                                baseStatementIds : statementHeader.FinancialStatementsForProjection,
                                accId : acc.Id,
                                statementType : statementHeader.StatementType,
                                statementDate : statementHeader.StatementDate,
                                monthsCovered : statementHeader.MonthsCovered,
                                params : parameters
                            }
                        );
});
skuid.snippet.register('SensitivityAnalysisRequest',function(args) {var params = arguments[0],
	$ = skuid.$;
	
var statementHeader = skuid.model.getModel('SensitivityAnalysis').data[0];
var statementParams = skuid.model.getModel('StatementParamsForSensitivityAnalysis').data;
var acc = skuid.model.getModel('ACStatementForAccount').data[0];

var parameters = "{";
var i;
var case1Params = "{";
var case2Params = "{";
var case3Params = "{";
for(i = 0; i< statementParams.length ; i++){
    console.log(statementParams[i]);
    case1Params += ("\"" + statementParams[i].TemplateDetail +"\""+ ": "+"\""+statementParams[i].Case1+"\""+",");
    case2Params += ("\"" + statementParams[i].TemplateDetail +"\""+ ": "+"\""+statementParams[i].Case2+"\""+",");
    case3Params += ("\"" + statementParams[i].TemplateDetail +"\""+ ": "+"\""+statementParams[i].Case3+"\""+",");
    /*parameters += ("\"" + statementParams[i].TemplateDetail +"\"" + ": {" + "\"" +"Case 1" +"\""+":"+"\""+statementParams[i].Case1+"\""+","+"\""+"Case 2"+"\""+":"+"\""+statementParams[i].Case2+"\""+","+"\""+"Case 3"+"\""+":"+"\""+statementParams[i].Case3+"\""+"}"+",");*/
}

case1Params = case1Params.slice(0,-1);
case1Params += "}";
case2Params = case2Params.slice(0,-1);
case2Params += "}";
case3Params = case3Params.slice(0,-1);
case3Params += "}";

parameters += ("\"" +"Case 1" +"\""+":"+case1Params+","+"\""+"Case 2"+"\""+":"+case2Params+","+"\""+"Case 3"+"\""+":" + case3Params);
parameters+="}";
console.log(parameters);

sforce.apex.execute('clcommon.CustomButtonAction', 'performSensitivityAnalysis', {
                                baseStatement : statementHeader.FinancialStatements,
                                accId : acc.Id,
                                statementType : statementHeader.StatementType,
                                params : parameters,
                                deletePreviousAnalysis : true
                            }
                        );
});
}(window.skuid));