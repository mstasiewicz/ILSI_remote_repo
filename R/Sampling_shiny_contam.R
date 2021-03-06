f_ui_dims = function(input, ...){
  if(input$spread_vs == "continuous"){
    verticalLayout(
      p("Q2. What are the dimensions of the field?"),
      splitLayout(
        numericInput(inputId = "x_lim_vs", label = "Length (m)", value = NULL, min = 1),
        numericInput(inputId = "y_lim_vs", label = "Width (m)", value = NULL, min = 1)
      ),
      p("Q3. How would you describe the geometry of the hazards?"),
      radioButtons(inputId = "geom_vs", 
                   label = NULL, 
                   choices = list("Point-source" = "point", "Area-based" = "area"),
                   selected = character(0), 
                   inline = TRUE)
    )
  } else if (input$spread_vs == "discrete"){
    verticalLayout(
      p("Q2. What are the dimensions of the grain bin?"),
      splitLayout(
        numericInput(inputId = "x_lim_3d_vs", label = "Length (m)", value = NULL, min = 1),
        numericInput(inputId = "y_lim_3d_vs", label = "Width (m)", value = NULL, min = 1),
        numericInput(inputId = "z_lim_3d_vs", label = "Height (m)", value = NULL, min = 1)
      )
    )
  } else {
    stop("Unknown spread type")
  }
}

f_ui_geom = function(input, ...) {
  if (input$geom_vs == "point") {
    verticalLayout(
      p("Q3A. Number of contamination points?"),
      numericInput(inputId = "n_contam_vs", label = NULL, value = NULL, min = 1, step = 1),
      p("Q3B. Radius of contamination area(m)?"),
      numericInput(inputId = "spread_radius_vs", label = NULL, value = NULL, min = 0)
    )
  } else {
    NULL
  }
}

f_ui_grain = function(input, ...){
  verticalLayout(
    p("Q3. What's the mass of a single kernel (g)?"),
    numericInput(inputId = "m_kbar_vs", label = NULL, value = 0.3, min = 0.001),
    p("Q4. What's the kernel density (g/cm^3) ?"),
    numericInput(inputId = "rho_vs", label = NULL, value = 1.28, min = 0.001)
  )
}

f_ui_contam = function(input, ...){
  if(input$spread_vs == "continuous"){
      verticalLayout(
        p("Q4. Mean contamination level (log CFU/g)"),
        numericInput(inputId = "cont_level_mu_vs", label = NULL, value = NULL),
        p("Q5. Standard deviation of contamination level (log CFU/g)"),
        numericInput(inputId = "cont_level_sd_vs", label = NULL, value = NULL),
        p("Q6. Background level (CFU/g)"),
        numericInput(inputId = "bg_level_vs", label = NULL, value = 0.00001, min = 0),
        p("Q7. Decay function"),
        radioButtons(inputId = "fun_vs",
                     label = NULL,
                     choices = list("Exponential" = "exp", "Gaussian" = "norm", "Uniform" = "unif"), 
                     selected = character(0), 
                     inline = TRUE),
        conditionalPanel(
          condition = "input.fun_vs == 'exp' | input.fun_vs == 'norm'",
          p("Q7A. How fast do you want the contamination to decay? (left: fast; right: slow)"),
          sliderInput(inputId = "LOC_vs", label = NULL, value = 0.001, min = 0.0001, max = 0.01, ticks = TRUE)
        )
      )
  } else if(input$spread_vs == "discrete"){
    verticalLayout(
      p("Q5. Which mycotoxin do you want to simulate?"), 
      selectInput(inputId = "tox_vs", label = NULL, choices = list("Aflatoxin" = "AF")),
      p("Q6. What's the mycotoxin regulatory threshold (ppb)?"),
      numericInput(inputId = "Mc_vs", label = NULL, value = 20, min = 0.001),
      p("Q7. What's the estimated overall mycotoxin level (ppb) in the bin?"),
      numericInput(inputId = "c_hat_vs", label = NULL, value = NULL, min = 0.001),
      p("Q8. How is the mycotoxin distributed in contaminated grains?"),
      radioButtons(inputId = "dis_level_type_vs", 
                  label = NULL, 
                  choices = list("Uniform" = "constant", "Gamma" = "Gamma"), 
                  selected = character(0), 
                  inline = TRUE),
      conditionalPanel(condition = "input.dis_level_type_vs == 'constant'",
                       p("Q8A. What's the estimated mycotoxin level (ppb) in contaminated grains?"),
                       numericInput(inputId = "dis_level_const_arg_vs", 
                                    label = NULL, 
                                    value = 40000, min = 0.001)),
      conditionalPanel(condition = "input.dis_level_type_vs == 'Gamma'",
                       p("Q8A. What's the most likely mycotoxin level (ppb) in contaminated grains?"),
                       numericInput(inputId = "dis_level_gm_mode_vs", 
                                    label = NULL, value = 40000),
                       p("Q8B. What's the lower bound of the mycotoxin level (ppb) in contaminated grains?"),
                       numericInput(inputId = "dis_level_gm_lb_vs", label = NULL,
                                    value = 20, min = 0.001)
      )
    )
  } else {
    NULL
  }
}

f_ui_n_affected = function(input,...){
  if(input$dis_level_type_vs %in% c("constant", "Gamma")){
    verticalLayout(
      p("Q9. How many kernels are estimated to be in a cluster? (MUST be >= 0)"),
      numericInput(inputId = "n_affected_vs", label = NULL, value = NULL, min = 0, step = 1),
      conditionalPanel(condition = "input.n_affected_vs > 0",
                       p("Q9A. Describe the cluster's spatial shape in the covariance matrix."),
                       wellPanel(
                         splitLayout(
                           numericInput(inputId = "vcov_11_vs", label = "Length", value = 0.0004, min = 0),
                           numericInput(inputId = "vcov_12_vs", label = "Width", value = 0, min = 0),
                           numericInput(inputId = "vcov_13_vs", label = "Height", value = 0, min = 0)
                         ),
                         splitLayout(
                           p(""),
                           numericInput(inputId = "vcov_22_vs", label = NULL, value = 0.0004, min = 0),
                           numericInput(inputId = "vcov_23_vs", label = NULL, value = 0, min = 0)
                         ),
                         splitLayout(
                           p(""),
                           p(""),
                           numericInput(inputId = "vcov_33_vs", label = NULL, value = 0.0004, min = 0)
                         )
                       ))
    )
  } else {
    NULL
  }
}
