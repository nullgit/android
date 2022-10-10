package com.yunzen.myapplication.lab2;

import java.util.List;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;

import com.yunzen.myapplication.R;

import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.activity.result.ActivityResultLauncher;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

public class RVAdapter extends RecyclerView.Adapter<RVAdapter.ViewHolder> {

    private static final String                  TAG = "RVAdapter";

    private final List<String>                   dataList;

    private final ActivityResultLauncher<Intent> register;

    RVAdapter(List<String> dataList, ActivityResultLauncher<Intent> register) {
        this.dataList = dataList;
        this.register = register;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new ViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.rv_item, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        holder.bind(dataList.get(position));
        holder.setPosition(position);
        holder.setRegister(register);
    }

    @Override
    public int getItemCount() {
        return CollectionUtils.size(dataList);
    }

    public void notifyItem(int position, String change) {
        if (position < 0 || position >= dataList.size()) {
            Log.e(TAG, "position = " + position);
            return;
        }
        if (StringUtils.isNoneBlank(change)) {
            dataList.set(position, change);
            notifyItemChanged(position);
        }
    }

    public static class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        private final TextView                 tv;

        private int                            position;

        private ActivityResultLauncher<Intent> register;

        ViewHolder(@NonNull View itemView) {
            super(itemView);
            tv = itemView.findViewById(R.id.tv);
            tv.setOnClickListener(this);
        }

        public void bind(String text) {
            tv.setText(text);
        }

        public void setPosition(int position) {
            this.position = position;
        }

        public void setRegister(ActivityResultLauncher<Intent> register) {
            this.register = register;
        }

        @Override
        public void onClick(View v) {
            TextView tv = (TextView) v;
            Log.d("d", "点击了" + tv.getText().toString());
            Intent intent = new Intent(tv.getContext(), ContentActivity.class);
            intent.putExtra("from", tv.getText().toString());
            intent.putExtra("position", position);
            register.launch(intent);
        }

    }

}
