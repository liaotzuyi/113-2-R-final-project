# 1. 載入 tidyverse
library(tidyverse)

# 2. 匯入 CSV 檔案為 native
native <- read_csv("/cloud/project/myDataFolder/臺北市政府各機關年度預算支用情形(政事別)(單位：元).csv")


# 3. 檢視前幾列資料
glimpse(native)  # 或用 head(native)

# 4. 重新命名欄位（請根據實際欄位內容修改）
native <- native %>%
  rename(
    category = 政事別名稱,
    budget = 年度預算數,
    allocated = 本年分配數,
    spent = 本年支付數
  )


# 5. 建立支出向量：抓稅率欄位 + 清理格式
spending_vector <- native$spent

# 6. 計算總支出
total_spent <- sum(spending_vector, na.rm = TRUE)


# 7. 打印總支出
print(total_spent)

# 8. 計算每個支出項目佔總支出的比例
native <- native %>%
  mutate(spent_ratio = spent / total_spent)

# 9. 將數據傳換為數據框（其實本來就是，只是為畫圖準備）
plot_data <- native %>%
  select(category, spent) 

# 10. #繪製條形圖
ggplot(plot_data, aes(x = reorder(category, spent), y = spent)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +  # 類別多時翻轉X、Y軸會更清楚
  labs(title = "各政事別支出情形", x = "政事別", y = "支出金額") +
  theme_minimal()
# 11. 查找最大支出項目
max_spent_item <- native %>% filter(spent == max(spent, na.rm = TRUE))

# 12. 查找最小支出項目
min_spent_item <- native %>% filter(spent == min(spent, na.rm = TRUE))

# 13. 打印結果
print("最大支出項目：")
print(max_spent_item)

print("最小支出項目：")
print(min_spent_item)

# 14. 查找所有分配數低於預算數的項目
under_allocated <- native %>%
  filter(allocated < budget)

# 15. 打印所有分配數低於預算數的項目及其金額
print("分配低於預算的項目：")
print(under_allocated %>% select(category, budget, allocated))


getwd()
