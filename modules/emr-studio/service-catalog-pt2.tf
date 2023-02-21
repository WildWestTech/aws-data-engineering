#In order to delete service-catalog-pt1.tf, we must delete this association first... 
# Adding the EMR_Studio_User_Role_DataEngineering Role to the portfolio
resource "aws_servicecatalog_principal_portfolio_association" "EMR_Cluster_Template_Portfolio" {
  portfolio_id  = aws_servicecatalog_portfolio.EMR_Cluster_Template_Portfolio.id
  principal_arn = "arn:aws:iam::${var.account}:role/EMRStudio_User_Role"
  depends_on = [
    aws_servicecatalog_portfolio.EMR_Cluster_Template_Portfolio
  ]
}