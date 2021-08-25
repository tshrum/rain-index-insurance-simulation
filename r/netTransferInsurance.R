# Net Transfer from Insurance

rMTurk %>%
  filter(trt == 1 & yr_num < 2008) %>%  # removing final year of the simulation
  distinct(yr, .keep_all = TRUE) %>%
  select(cost.ins, rev.ins) %>% 
  summarize(premiums = sum(cost.ins), payouts = sum(rev.ins)) %>%
  mutate(netTransfer = payouts - premiums) -> netMTurk

rRanchers %>%
  filter(trt == 1 & yr_num < 2007 ) %>% 
  distinct(yr, .keep_all = TRUE) %>%
  select(cost.ins, rev.ins) %>%
  summarize(premiums = sum(cost.ins), payouts = sum(rev.ins)) %>%
  mutate(netTransfer = payouts - premiums) -> netRanchers6yrs

rRanchers %>%
  filter(trt == 1 & insured == 1) %>% 
  distinct(yr, .keep_all = TRUE) %>%
  select(cost.ins, rev.ins) %>%
  summarize(premiums = sum(cost.ins), payouts = sum(rev.ins)) %>%
  mutate(netTransfer = payouts - premiums) -> netRanchers8yrs
