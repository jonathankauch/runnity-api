// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {
  // $('#runs_by_month').attr('data-attr');
  var optionsResponsiveNoScale = {
    responsive: true,
    maintainAspectRatio: false
  };
  var canvasRunNbMonthChart = document.getElementById("runNbMonthChart");
  var data = {
    labels: ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"],
    datasets: [
        {
            label: "Nombre de courses",
            backgroundColor: 'rgba(75, 192, 192, 1)',
            borderColor: 'rgba(75, 192, 192, 0.7)',
            fill: false,
            lineTension: 0,
            data: JSON.parse($('#runs_by_month').attr('data-attr')),
        }
    ]
  };
  var runNbChart = new Chart(canvasRunNbMonthChart, {
      type: 'line',
      data: data,
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          yAxes: [{
            scaleLabel: {
              padding: 4,
            },
            ticks: {
              min: 0,
              beginAtZero:true,
              stepSize: 1
            }
          }]
        }
      }
  });

  var canvasdistanceMonthChart = document.getElementById("distanceMonthChart");
  var data = {
    labels: ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"],
    datasets: [
        {
            label: "Km",
            backgroundColor: 'rgba(255, 99, 132, 1)',
            borderColor: 'rgba(255, 99, 132, 0.7)',
            fill: false,
            lineTension: 0,
            data: JSON.parse($('#distance_by_month').attr('data-attr')),
        }
    ]
  };
  var distanceChart = new Chart(canvasdistanceMonthChart, {
      type: 'line',
      data: data,
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          yAxes: [{
            scaleLabel: {
              padding: 4,
            },
            ticks: {
              min: 0,
              beginAtZero:true
            }
          }]
        }
      }
  });

  var canvastimeMonthChart = document.getElementById("timeMonthChart");
  var data = {
    labels: ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"],
    datasets: [
        {
            label: "Minutes",
            backgroundColor: 'rgba(153, 102, 255, 1)',
            borderColor: 'rgba(153, 102, 255, 0.7)',
            fill: false,
            lineTension: 0,
            data: JSON.parse($('#time_run_by_month').attr('data-attr')),
        }
    ]
  };
  var timeChart = new Chart(canvastimeMonthChart, {
      type: 'line',
      data: data,
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          yAxes: [{
            scaleLabel: {
              padding: 4,
            },
            ticks: {
              min: 0,
              beginAtZero:true
            }
          }]
        }
      }
  });

  var canvascaloriesMonthChart = document.getElementById("caloriesMonthChart");
  var data = {
    labels: ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre"],
    datasets: [
        {
            label: "Calories",
            fill: false,
            backgroundColor: ['rgba(139, 195, 74, 1)'],
            borderColor: ['rgba(139, 195, 74, 0.7)'],
            lineTension: 0,
            data: JSON.parse($('#calories_by_month').attr('data-attr')),
        }
    ]
  };
  var timeChart = new Chart(canvascaloriesMonthChart, {
      type: 'line',
      data: data,
      options: {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
          yAxes: [{
            scaleLabel: {
              padding: 4,
            },
            ticks: {
              min: 0,
              beginAtZero:true
            }
          }]
        }
      }
  });
  // var canvasSkillChart = document.getElementById("skillChart");
  // data = {
  //     labels: ["Eating", "Drinking", "Sleeping", "Designing", "Coding", "Cycling", "Running"],
  //     datasets: [
  //         {
  //             label: "Arbre de competence",
  //             backgroundColor: "rgba(179,181,198,0.2)",
  //             borderColor: "rgba(179,181,198,1)",
  //             pointBackgroundColor: "rgba(179,181,198,1)",
  //             pointBorderColor: "#fff",
  //             pointHoverBackgroundColor: "#fff",
  //             pointHoverBorderColor: "rgba(179,181,198,1)",
  //             data: [65, 59, 90, 81, 56, 55, 40]
  //         },
  //         {
  //             label: "My Second dataset",
  //             backgroundColor: "rgba(255,99,132,0.2)",
  //             borderColor: "rgba(255,99,132,1)",
  //             pointBackgroundColor: "rgba(255,99,132,1)",
  //             pointBorderColor: "#fff",
  //             pointHoverBackgroundColor: "#fff",
  //             pointHoverBorderColor: "rgba(255,99,132,1)",
  //             data: [28, 48, 40, 19, 96, 27, 100]
  //         }
  //     ]
  // };
  // var skillChart = new Chart(canvasSkillChart, {
  //   type: 'radar',
  //   data: data,
  //   options: optionsResponsiveNoScale
  // });
  // var canvasWeightChart = document.getElementById("weightChart");
  // data = {
  //   labels: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
  //   datasets: [
  //       {
  //           label: "Evolution du poids",
  //           fill: true,
  //           lineTension: 0.1,
  //           backgroundColor: "rgba(75,192,192,0.4)",
  //           borderColor: "rgba(75,192,192,1)",
  //           borderCapStyle: 'butt',
  //           borderDash: [],
  //           borderDashOffset: 0.0,
  //           borderJoinStyle: 'miter',
  //           pointBorderColor: "rgba(75, 192, 192, 1)",
  //           pointBackgroundColor: "#fff",
  //           pointBorderWidth: 1,
  //           pointHoverRadius: 5,
  //           pointHoverBackgroundColor: "rgba(75, 192, 192, 1)",
  //           pointHoverBorderColor: "rgba(220, 220, 220, 1)",
  //           pointHoverBorderWidth: 2,
  //           pointRadius: 1,
  //           pointHitRadius: 10,
  //           data: [75, 77, 74, 77, 80, 78, 77, 75, 73, 70, 69, 68],
  //           spanGaps: false,
  //       }
  //   ]
  // };
  // var weightChart = new Chart(canvasWeightChart, {
  //   type: 'line',
  //   data: data,
  //   options: {
  //     scales: {
  //       yAxes: [{
  //           display: true,
  //           ticks: {
  //               suggestedMin: 0, // minimum will be 0, unless there is a lower value.
  //               suggestedMax: 150, // minimum will be 0, unless there is a lower value.
  //           }
  //       }]
  //     },
  //     responsive: true,
  //     maintainAspectRatio: false
  //   }
  // });
  // var canvasStepPerDayChart = document.getElementById("stepPerDayChart");
  // data = {
  //   labels: ["Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"],
  //   datasets: [
  //       {
  //           label: "Nombre de pas par jour",
  //           fill: true,
  //           lineTension: 0.1,
  //           backgroundColor: "rgba(179, 181, 198, 0.2)",
  //           borderColor: "rgba(179, 181, 198, 1)",
  //           borderCapStyle: 'butt',
  //           borderDash: [],
  //           borderDashOffset: 0.0,
  //           borderJoinStyle: 'miter',
  //           pointBorderColor: "rgba(75, 192, 192, 1)",
  //           pointBackgroundColor: "#fff",
  //           pointBorderWidth: 1,
  //           pointHoverRadius: 5,
  //           pointHoverBackgroundColor: "rgba(75, 192, 192, 1)",
  //           pointHoverBorderColor: "rgba(220, 220, 220, 1)",
  //           pointHoverBorderWidth: 2,
  //           pointRadius: 1,
  //           pointHitRadius: 10,
  //           data: [10001, 17030, 12002, 14000, 12035, 12889, 15356],
  //           spanGaps: false,
  //       }
  //   ]
  // };
  // var stepPerDayChart = new Chart(canvasStepPerDayChart, {
  //   type: 'line',
  //   data: data,
  //   options: {
  //     scales: {
  //       yAxes: [{
  //           display: true,
  //           ticks: {
  //               suggestedMin: 0, // minimum will be 0, unless there is a lower value.
  //               suggestedMax: 150, // minimum will be 0, unless there is a lower value.
  //           }
  //       }]
  //     },
  //     responsive: true,
  //     maintainAspectRatio: false
  //   }
  // });
  // var canvasStepPerWeekChart = document.getElementById("stepPerWeekChart");
  // var data = {
  //   labels: ["1ere sem", "2eme sem", "3eme sem", "4eme sem"],
  //   datasets: [
  //       {
  //           label: "Nombre de pas par semaine",
  //           backgroundColor: [
  //               'rgba(255, 99, 132, 0.2)',
  //               'rgba(54, 162, 235, 0.2)',
  //               'rgba(255, 206, 86, 0.2)',
  //               'rgba(231, 76, 60, 0.2)'
  //           ],
  //           data: [55002, 60244, 62323, 45023],
  //       }
  //   ]
  // };
  // var stepPerWeekChart = new Chart(canvasStepPerWeekChart, {
  //     type: 'bar',
  //     data: data,
  //     options: {
  //       responsive: true,
  //       maintainAspectRatio: false,
  //       scales: {
  //         yAxes: [{
  //           ticks: {
  //             beginAtZero:true
  //           }
  //         }]
  //       }
  //     }
  // });
});
