library(datasets)
data(USArrests)

worststates<-function(colid) {
  colnum<-as.numeric(colid)
  crimeinfo<-colnames(USArrests)[colnum]
  USArrests$State<-rownames(USArrests)
  USArrests$CrimeRank<-rank(-1*USArrests[,colnum])
  lastcol<-dim(USArrests)[2]
  ranktitle<-paste(crimeinfo,"Rank")
  dimnames(USArrests)[[2]][lastcol]<-ranktitle
  worststates<-USArrests[order(USArrests[,colnum],decreasing=TRUE),]
  worststates<-worststates[c("State",ranktitle,"Murder","Rape","Assault")]
}

rankstate<-function(stateid,colid) {
rowid<-grep(stateid,rownames(USArrests))
colnum<-as.numeric(colid)
staterank<-rank(-1*USArrests[,colnum])[rowid]
staterank
}

statestats<-function(stateid,colid) {
  rowid<-grep(stateid,rownames(USArrests))  
  colnum<-as.numeric(colid)
statesumm<-paste(stateid,"has",USArrests[rowid,colnum],"arrests for",colnames(USArrests)[colnum],"per 100k residents")
  statesumm
}


library(shiny)
shinyServer(
  function(input, output) {
    output$stateout<-renderPrint({input$statein})
    output$crimeout<-renderPrint({input$crimein})
    output$staterank<-renderPrint({rankstate(input$statein,input$crimein)})
    output$statesumm<-renderPrint({statestats(input$statein,input$crimein)})
   
    output$newHist <- renderPlot({
      hist(USArrests[,as.numeric(input$crimein)], xlab='# per 100k Residents', col='lightblue',main='Histogram')
      mu <- USArrests[grep(input$statein,rownames(USArrests)),as.numeric(input$crimein)]
      lines(c(mu, mu), c(0, 200),col="red",lwd=5)
    })   
    output$worststates<-renderDataTable({worststates(input$crimein)},options = list(pageLength = 10))
    
  }
)